//
//  APIClient.swift
//  feed
//
//  Created by Rance Tsai on 10/3/20.
//

import Foundation

enum APIClientError: Error {
    case unknown
}

protocol APIClientProtocol {
    func get(_ url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

class APIClient: APIClientProtocol {
    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func get(_ url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        urlSession.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(APIClientError.unknown))
            }
        }
        .resume()
    }
}
