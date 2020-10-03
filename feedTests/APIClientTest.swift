//
//  APIClientTest.swift
//  feedTests
//
//  Created by Rance Tsai on 10/3/20.
//

import XCTest
@testable import feed

private enum SomeError: Error {
    case some
}

final class APIClientTest: XCTestCase {
    private let url = URL(string: "https://www.google.com")!

    func testSuccessCase() throws {
        let testData = "test".data(using: .ascii)
        let urlSession = URLSessionMock(data: testData)
        let apiClient = APIClient(urlSession: urlSession)
        let promise = XCTestExpectation()

        apiClient.get(url) { result in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, testData)
            case .failure:
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1)
    }

    func testFailureCase() throws {
        let urlSession = URLSessionMock(error: SomeError.some)
        let apiClient = APIClient(urlSession: urlSession)
        let promise = XCTestExpectation()

        apiClient.get(url) { result in
            switch result {
            case .success:
                XCTFail()
            case let .failure(error):
                XCTAssertEqual(error as? SomeError, SomeError.some)
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1)
    }
}
