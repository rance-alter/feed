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

    func loadTopStories(completion: @escaping (Error?) -> Void)
    func loadStory(_ story: Story, completion: @escaping (Result<Story, Error>) -> Void)
}

final class MainViewModel: MainViewModelProtocol {
    private let service: HackerNewsServiceProtocol
    private let realmProvider: RealmProvidering
    private let queue = DispatchQueue(label: "tw.rance.feed.stories", attributes: .concurrent)
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

    func loadTopStories(completion: @escaping (Error?) -> Void) {
        service.loadTopStories { [weak self] result in
            guard let sself = self else { return }
            let realm = sself.realmProvider.realm()

            switch result {
            case let .success(ids):
                let stories = ids.map { Story(id: $0) }
                sself.stories = stories

                let realmStories = stories.map { RealmStory(story: $0) }
                try? realm.write {
                    realm.deleteAll()
                    realm.add(realmStories)
                }
                completion(nil)
            case let .failure(error):
                let realmStories = realm.objects(RealmStory.self)
                sself.stories = realmStories.map { Story(realm: $0) }
                completion(error)
            }
        }
    }

    func loadStory(_ story: Story, completion: @escaping (Result<Story, Error>) -> Void) {
        guard !story.isLoaded else { return }

        service.loadItem(id: story.id) { [weak self] (result: Result<Story, Error>) in
            guard let sself = self else { return }
            switch result {
            case let .success(story):
                if let index = sself.stories.firstIndex(of: story) {
                    let realm = sself.realmProvider.realm()
                    if story.isHidden {
                        sself.stories.remove(at: index)

                        let realmStories = realm.objects(RealmStory.self).filter("id = \(story.id)")
                        try? realm.write {
                            realm.delete(realmStories)
                        }
                        completion(.failure(MainViewModelError.hiddenItem))
                    } else {
                        sself.stories[index] = story
                        try? realm.write {
                            realm.add(RealmStory(story: story), update: .modified)
                        }
                        completion(.success(story))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
