//
//  URLSessionMock.swift
//  feedTests
//
//  Created by Rance Tsai on 10/3/20.
//

import Foundation

final class URLSessionMock: URLSession {
    private let data: Data?
    private let error: Error?

    init(data: Data? = nil, error: Error? = nil) {
        self.data = data
        self.error = error
    }

    override func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {

        let data = self.data
        let error = self.error

        return URLSessionDataTaskMock {
            completionHandler(data, nil, error)
        }
    }
}
