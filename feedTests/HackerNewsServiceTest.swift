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

    func testLoadStory() throws {
        let apiClient = APIClientMock(dataFromFilename: "story", ext: "json")
        let service = HackerNewsService(apiClient: apiClient)
        let promise = XCTestExpectation()

        service.loadItem(id: 0) { (result: Result<Story, Error>) in
            switch result {
            case let .success(story):
                XCTAssertEqual(story.author, "dhouston")
                XCTAssertEqual(story.numberOfComments, 71)
                XCTAssertEqual(story.id, 8863)
                XCTAssertEqual(story.commentIds, [8952, 8876])
                XCTAssertEqual(story.score, 11122223)
                XCTAssertEqual(story.creationTime, Date(timeIntervalSince1970: 1175714200))
                XCTAssertEqual(story.title, "Prism. The perfect OAS (Swagger) companion.")
                XCTAssertEqual(story.type, .story)
                XCTAssertEqual(story.url, URL(string: "http://stoplight.io/prism/"))
            case .failure:
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1)
    }
}
