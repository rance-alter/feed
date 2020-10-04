//
//  SkippableAPIClient.swift
//  feed
//
//  Created by Rance Tsai on 10/5/20.
//

import Foundation

final class SkippableAPIClient: APIClient {
    typealias CompletionHandler = (Result<Data, Error>) -> Void

    private let queue = DispatchQueue(label: "tw.rance.feed.urls", attributes: .concurrent)
    private var _urls = Set<URL>()

    private var urls: Set<URL> {
        get {
            queue.sync { _urls }
        }
        set {
            queue.sync(flags: .barrier) {
                _urls = newValue
            }
        }
    }

    override func get(_ url: URL, completion: @escaping CompletionHandler) {
        guard !urls.contains(url) else { return }
        urls.insert(url)
        super.get(url) { [weak self] result in
            switch result {
            case let .success(data):
                completion(.success(data))
            case let .failure(error):
                completion(.failure(error))
            }
            self?.urls.remove(url)
        }
    }
}
