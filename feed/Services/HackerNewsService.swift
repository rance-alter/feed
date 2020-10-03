//
//  HackerNewsService.swift
//  feed
//
//  Created by Rance Tsai on 10/3/20.
//

import Foundation

protocol HackerNewsServiceProtocol {
    func loadTopStories(completion: @escaping (Result<[Int], Error>) -> Void)
}

final class HackerNewsService: HackerNewsServiceProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func loadTopStories(completion: @escaping (Result<[Int], Error>) -> Void) {
        loadJSON(.topStories, completion: completion)
    }

    private func loadJSON<T: Decodable>(
        _ endpoint: HackerNewsEndpoint,
        completion: @escaping (Result<T, Error>) -> Void) {

        apiClient.get(endpoint.url()) { result in
            switch result {
            case let .success(data):
                do {
                    let value = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(value))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
