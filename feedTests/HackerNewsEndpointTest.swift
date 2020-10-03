//
//  HackerNewsEndpointTest.swift
//  feedTests
//
//  Created by Rance Tsai on 10/3/20.
//

import XCTest
@testable import feed

final class HackerNewsEndpointTest: XCTestCase {
    func testURL() throws {
        XCTAssertEqual(
            HackerNewsEndpoint.topStories.url().absoluteString,
            "https://hacker-news.firebaseio.com/v0/topstories")
        XCTAssertEqual(
            ItemEndpoint(id: 123).url().absoluteString,
            "https://hacker-news.firebaseio.com/v0/item/123.json")
    }
}
