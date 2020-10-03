//
//  APIClientMock.swift
//  feedTests
//
//  Created by Rance Tsai on 10/3/20.
//

import Foundation
@testable import feed

final class APIClientMock: APIClientProtocol {
    private let data: Data?
    private let error: Error?

    init(jsonString: String? = nil, error: Error? = nil) {
        data = jsonString?.data(using: .utf8)
        self.error = error
    }

    init(dataFromFilename filename: String, ext: String) {
        let bundle = Bundle(for: Self.self)
        data = try? bundle.url(forResource: filename, withExtension: ext)
            .flatMap { try Data(contentsOf: $0) }
        error = nil
    }

    func get(_ url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        if let data = data {
            completion(.success(data))
        } else if let error = error {
            completion(.failure(error))
        }
    }
}
