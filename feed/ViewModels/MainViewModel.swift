//
//  MainViewModel.swift
//  feed
//
//  Created by Rance Tsai on 10/4/20.
//

import Foundation
import RealmSwift

enum MainViewModelError: Error {
    case hiddenItem
}

protocol MainViewModelProtocol {
    var numberOfItems: Int { get }
    func story(at index: Int) -> Story?
    func loadTopStories(id: Int?, completion: @escaping (Int?, Error?) -> Void)
}

final class MainViewModel: MainViewModelProtocol {
    private static let pageSize = 20

    private let service: HackerNewsServiceProtocol
    private let realmProvider: RealmProvidering
    private let queue = DispatchQueue(label: "tw.rance.feed.stories", attributes: .concurrent)
    private var storyIDs = [Int]()
    private var _stories = [Story]()

    private var stories: [Story] {
        get {
            queue.sync { _stories }
        }
        set {
            queue.sync(flags: .barrier) {
                _stories = newValue
            }
        }
    }

    init(
        service: HackerNewsServiceProtocol = HackerNewsService(),
        realmProvider: RealmProvidering = RealmProvider()) {

        self.service = service
        self.realmProvider = realmProvider
    }

    var numberOfItems: Int {
        stories.count
    }

    func story(at index: Int) -> Story? {
        queue.sync {
            guard 0 ..< _stories.count ~= index else { return nil }
            return _stories[index]
        }
    }

    func loadTopStories(id: Int?, completion: @escaping (Int?, Error?) -> Void) {
        if let id = id {
            loadStories(id: id) { nextID in
                completion(nextID, nil)
            }
        } else {
            service.loadTopStories { [weak self] result in
                guard let sself = self else { return }
                let realm = sself.realmProvider.realm()
                switch result {
                case let .success(ids):
                    sself.storyIDs = ids
                    sself.stories.removeAll()
                    try? realm.write {
                        realm.deleteAll()
                    }
                    sself.loadStories { nextID in
                        completion(nextID, nil)
                    }
                case let .failure(error):
                    let realmStories = realm.objects(RealmStory.self)
                    sself.stories = realmStories.map { Story(realm: $0) }
                    completion(nil, error)
                }
            }
        }
    }

    private func loadStories(id: Int = 0, completion: @escaping (Int?) -> Void) {
        let index = storyIDs.firstIndex(of: id) ?? 0
        let ids = Array(storyIDs[index ..< min(index + Self.pageSize, storyIDs.endIndex)])
        let nextID = index + Self.pageSize >= storyIDs.endIndex ? nil : storyIDs[index + Self.pageSize]
        let queue = DispatchQueue(label: "tw.rance.feed.story", attributes: .concurrent)
        let group = DispatchGroup()
        var storyMap = [Int: Story]()

        ids.forEach { [weak self] id in
            group.enter()
            self?.service.loadItem(id: id) { (result: Result<Story, Error>) in
                switch result {
                case let .success(story):
                    if !story.isHidden {
                        queue.sync(flags: .barrier) {
                            storyMap[id] = story
                        }
                    }
                case .failure:
                    break
                }
                group.leave()
            }
        }
        group.notify(queue: DispatchQueue.global()) {
            let stories: [Story] = ids.reduce(into: []) {
                if let story = storyMap[$1] {
                    $0.append(story)
                }
            }
            self.stories.append(contentsOf: stories)
            let realm = self.realmProvider.realm()
            let realmStories = stories.map { RealmStory(story: $0) }

            try? realm.write {
                realm.add(realmStories)
            }
            completion(nextID)
        }
    }
}
