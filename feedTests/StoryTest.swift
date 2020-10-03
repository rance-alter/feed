//
//  StoryTest.swift
//  feedTests
//
//  Created by Rance Tsai on 10/3/20.
//

import XCTest
@testable import feed

final class StoryTest: XCTestCase {
    private static var bundle: Bundle?

    override class func setUp() {
        super.setUp()
        bundle = Bundle(for: Self.self)
    }

    func testDecodingNormalJSON() throws {
        let name = "story"
        guard let story = try decodeStory(name: name) else {
            XCTFail("Failed to load \(name).json")
            return
        }
        XCTAssertEqual(story.author, "dhouston")
        XCTAssertEqual(story.numberOfComments, 71)
        XCTAssertEqual(story.id, 8863)
        XCTAssertEqual(story.commentIds, [8952, 8876])
        XCTAssertEqual(story.score, 11122223)
        XCTAssertEqual(story.creationTime, Date(timeIntervalSince1970: 1175714200))
        XCTAssertEqual(story.title, "Prism. The perfect OAS (Swagger) companion.")
        XCTAssertEqual(story.type, .story)
        XCTAssertEqual(story.url, URL(string: "http://stoplight.io/prism/"))
    }

    func testDecodingTinyJSON() throws {
        let name = "story_tiny"
        guard let story = try decodeStory(name: name) else {
            XCTFail("Failed to load \(name).json")
            return
        }
        XCTAssertNil(story.author)
        XCTAssertNil(story.numberOfComments)
        XCTAssertEqual(story.id, 8863)
        XCTAssertNil(story.commentIds)
        XCTAssertNil(story.score)
        XCTAssertNil(story.creationTime)
        XCTAssertNil(story.title)
        XCTAssertEqual(story.type, .story)
        XCTAssertNil(story.url)
    }

    private func decodeStory(name: String) throws -> Story? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970

        return try Self.bundle?.url(forResource: name, withExtension: "json")
            .flatMap { try Data(contentsOf: $0) }
            .map { try decoder.decode(Story.self, from: $0) }
    }
}
