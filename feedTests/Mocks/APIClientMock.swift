//
//  APIClientMock.swift
//  feedTests
//
//  Created by Rance Tsai on 10/3/20.
//

import Foundation
@testable import feed

struct APIClientMock: APIClientProtocol {
    private let data: Data?
    private let error: Error?

    init(jsonString: String? = nil, error: Error? = nil) {
        self.data = jsonString?.data(using: .utf8)
        self.error = error
    }

    func get(_ url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        if let data = data {
            completion(.success(data))
        } else if let error = error {
            completion(.failure(error))
        }
    }
}
