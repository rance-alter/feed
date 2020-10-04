//
//  MainViewModel.swift
//  feed
//
//  Created by Rance Tsai on 10/4/20.
//

import Foundation

protocol MainViewModelProtocol {
    func loadTopStories(completion: @escaping (Error?) -> Void)
    func loadStory(_ story: Story, completion: @escaping () -> Void)
}

final class MainViewModel: MainViewModelProtocol {
    enum Section {
        case topStories
    }

    private let service: HackerNewsServiceProtocol
    private let queue = DispatchQueue(label: "tw.rance.feed.stories", attributes: .concurrent)
    private var _stories = [Story]()

    private(set) var stories: [Story] {
        get {
            queue.sync { _stories }
        }
        set {
            queue.sync(flags: .barrier) {
                _stories = newValue
            }
        }
    }

    init(service: HackerNewsServiceProtocol = HackerNewsService()) {
        self.service = service
    }

    func loadTopStories(completion: @escaping (Error?) -> Void) {
        service.loadTopStories { [weak self] result in
            guard let sself = self else { return }
            switch result {
            case let .success(ids):
                sself.stories = ids.map { Story(id: $0) }
                completion(nil)
            case let .failure(error):
                completion(error)
            }
        }
    }

    func loadStory(_ story: Story, completion: @escaping () -> Void) {
        guard story.creationTime == nil else { return }

        service.loadItem(id: story.id) { [weak self] (result: Result<Story, Error>) in
            guard let sself = self else { return }
            switch result {
            case let .success(story):
                if let index = sself.stories.firstIndex(of: story) {
                    if story.isDeleted == true || story.isDead == true {
                        sself.stories.remove(at: index)
                    } else {
                        sself.stories[index] = story
                    }
                }
            case .failure:
                break
            }
            completion()
        }
    }
}
