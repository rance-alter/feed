//
//  HackerNewsService.swift
//  feed
//
//  Created by Rance Tsai on 10/3/20.
//

import Foundation

protocol HackerNewsServiceProtocol {
    func loadTopStories(completion: @escaping (Result<[Int], Error>) -> Void)
    func loadItem<T: Item>(id: Int, completion: @escaping (Result<T, Error>) -> Void)
}

final class HackerNewsService: HackerNewsServiceProtocol {
    private let apiClient: APIClientProtocol

    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func loadTopStories(completion: @escaping (Result<[Int], Error>) -> Void) {
        loadJSON(HackerNewsEndpoint.topStories, completion: completion)
    }

    func loadItem<T: Item>(id: Int, completion: @escaping (Result<T, Error>) -> Void) {
        loadJSON(ItemEndpoint(id: id), completion: completion)
    }

    private func loadJSON<T: Decodable>(
        _ endpoint: HackerNewsEndpointProtocol,
        completion: @escaping (Result<T, Error>) -> Void) {

        apiClient.get(endpoint.url()) { result in
            switch result {
            case let .success(data):
                do {
                    let value = try self.jsonDecoder.decode(T.self, from: data)
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
