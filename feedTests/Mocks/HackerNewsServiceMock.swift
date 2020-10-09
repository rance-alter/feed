//
//  HackerNewsServiceMock.swift
//  feedTests
//
//  Created by Rance Tsai on 10/4/20.
//

import Foundation
@testable import feed

protocol HackerNewsServiceMockDataSourceProtocol: class {
    var error: Error? { get }
    var topStoryIDs: [Int] { get }
    func item<T: Item>(id: Int) -> T?
}

class HackerNewsServiceMockDataSource: HackerNewsServiceMockDataSourceProtocol {
    var error: Error?
    var topStoryIDs = [Int]()
    var itemMap = [Int: Item]()

    func item<T: Item>(id: Int) -> T? {
        itemMap[id] as? T
    }
}

final class HackerNewsServiceMock: HackerNewsServiceProtocol {
    weak var dataSource: HackerNewsServiceMockDataSourceProtocol?

    func loadTopStories(completion: @escaping (Result<[Int], Error>) -> Void) {
        guard let dataSource = dataSource else { return }
        if let error = dataSource.error {
            completion(.failure(error))
        } else {
            completion(.success(dataSource.topStoryIDs))
        }
    }

    func loadItem<T: Item>(id: Int, completion: @escaping (Result<T, Error>) -> Void) {
        guard let dataSource = dataSource else { return }
        if let error = dataSource.error {
            completion(.failure(error))
        } else if let item = dataSource.item(id: id) as? T {
            completion(.success(item))
        }
    }
}
