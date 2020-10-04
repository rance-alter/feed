//
//  StoryTableViewCellViewModelTest.swift
//  feedTests
//
//  Created by Rance Tsai on 10/4/20.
//

import XCTest
@testable import feed

final class StoryTableViewCellViewModelTest: XCTestCase {

    func testNormalData() throws {
        let story: Story = JSONLoader.load(filename: "story")!
        let now = Date(timeIntervalSince1970: 1175724200)
        let vm = StoryTableViewCellViewModel(story: story, now: now)
        XCTAssertTrue(vm.isLoaded)
        XCTAssertEqual(vm.title, "Prism. The perfect OAS (Swagger) companion.")
        XCTAssertEqual(vm.subtitle, "11122223 points by dhouston 2 hours ago | 71 comments")
    }

    func testSkeletonData() throws {
        let story = Story(id: 123)
        let vm = StoryTableViewCellViewModel(story: story)
        XCTAssertFalse(vm.isLoaded)
        XCTAssertEqual(vm.title, "No title")
        XCTAssertEqual(vm.subtitle, "0 points by unknown user | 0 comments")
    }
}
