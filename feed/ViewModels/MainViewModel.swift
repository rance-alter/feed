//
//  MainViewModel.swift
//  feed
//
//  Created by Rance Tsai on 10/4/20.
//

import Foundation

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

    init(service: HackerNewsServiceProtocol = HackerNewsService()) {
        self.service = service
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
            switch result {
            case let .success(ids):
                sself.stories = ids.map { Story(id: $0) }
                completion(nil)
            case let .failure(error):
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
                    if story.isHidden {
                        sself.stories.remove(at: index)
                        completion(.failure(MainViewModelError.hiddenItem))
                    } else {
                        sself.stories[index] = story
                        completion(.success(story))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
