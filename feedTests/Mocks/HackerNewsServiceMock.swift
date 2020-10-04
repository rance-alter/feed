//
//  HackerNewsServiceMock.swift
//  feedTests
//
//  Created by Rance Tsai on 10/4/20.
//

import Foundation
@testable import feed

final class HackerNewsServiceMock: HackerNewsServiceProtocol {
    var topStoryIds = [Int]()
    var item: Item?
    var error: Error?

    func loadTopStories(completion: @escaping (Result<[Int], Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(topStoryIds))
        }
    }

    func loadItem<T: Item>(id: Int, completion: @escaping (Result<T, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else if let item = item as? T {
            completion(.success(item))
        }
    }
}
