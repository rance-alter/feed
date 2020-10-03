//
//  URLSessionDataTaskMock.swift
//  feedTests
//
//  Created by Rance Tsai on 10/3/20.
//

import Foundation

final class URLSessionDataTaskMock: URLSessionDataTask {
    private let completion: () -> Void

    init(completion: @escaping () -> Void) {
        self.completion = completion
    }

    override func resume() {
        completion()
    }
}
