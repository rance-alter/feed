//
//  StoryTest.swift
//  feedTests
//
//  Created by Rance Tsai on 10/3/20.
//

import XCTest
@testable import feed

final class StoryTest: XCTestCase {

    func testDecodingNormalJSON() throws {
        let story: Story = JSONLoader.load(filename: "story")!
        XCTAssertEqual(story.author, "dhouston")
        XCTAssertEqual(story.numberOfComments, 71)
        XCTAssertEqual(story.id, 8863)
        XCTAssertEqual(story.score, 11122223)
        XCTAssertEqual(story.creationTime, Date(timeIntervalSince1970: 1175714200))
        XCTAssertEqual(story.title, "Prism. The perfect OAS (Swagger) companion.")
        XCTAssertEqual(story.type, .story)
        XCTAssertEqual(story.url, URL(string: "http://stoplight.io/prism/"))
        XCTAssertTrue(story.isLoaded)
    }

    func testDecodingTinyJSON() throws {
        let story: Story = JSONLoader.load(filename: "story_tiny")!
        XCTAssertNil(story.author)
        XCTAssertNil(story.numberOfComments)
        XCTAssertEqual(story.id, 8863)
        XCTAssertNil(story.score)
        XCTAssertNil(story.creationTime)
        XCTAssertNil(story.title)
        XCTAssertEqual(story.type, .story)
        XCTAssertNil(story.url)
        XCTAssertFalse(story.isLoaded)
    }

    func testInit() throws {
        let id = 123
        let story = Story(id: id)
        XCTAssertNil(story.author)
        XCTAssertNil(story.numberOfComments)
        XCTAssertEqual(story.id, id)
        XCTAssertNil(story.score)
        XCTAssertNil(story.creationTime)
        XCTAssertNil(story.title)
        XCTAssertEqual(story.type, .story)
        XCTAssertNil(story.url)
    }
}
