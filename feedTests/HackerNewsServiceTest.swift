//
//  HackerNewsServiceTest.swift
//  feedTests
//
//  Created by Rance Tsai on 10/3/20.
//

import XCTest
@testable import feed

private enum SomeError: Error {
    case some
}

final class HackerNewsServiceTest: XCTestCase {

    func testLoadTopStoriesSuccess() throws {
        let apiClient = APIClientMock(jsonString: "[1,2,3]")
        let service = HackerNewsService(apiClient: apiClient)
        let promise = XCTestExpectation()

        service.loadTopStories { result in
            switch result {
            case let .success(ids):
                XCTAssertEqual(ids, [1, 2, 3])
            case .failure:
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1)
    }

    func testLoadTopStoriesFailure() throws {
        let apiClient = APIClientMock(error: SomeError.some)
        let service = HackerNewsService(apiClient: apiClient)
        let promise = XCTestExpectation()

        service.loadTopStories { result in
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
