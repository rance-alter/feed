//
//  MainViewModelTest.swift
//  feedTests
//
//  Created by Rance Tsai on 10/4/20.
//

import XCTest
@testable import feed

private enum SomeError: Error {
    case some
}

final class MainViewModelTest: XCTestCase {
    private let service = HackerNewsServiceMock()

    private lazy var viewModel: MainViewModel = {
        MainViewModel(service: self.service)
    }()

    override func setUpWithError() throws {
        service.topStoryIds = []
        service.item = nil
        service.error = nil
    }

    func testLoadStories() throws {
        let ids = [1, 2, 3]
        let skeletonStories = ids.map { Story(id: $0) }
        let promise = XCTestExpectation()
        service.topStoryIds = ids
        viewModel.loadTopStories { error in
            XCTAssertNil(error)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1)
        XCTAssertEqual(viewModel.stories, skeletonStories)

        let promise2 = XCTestExpectation()
        service.error = SomeError.some
        viewModel.loadTopStories { error in
            XCTAssertEqual(error as? SomeError, SomeError.some)
            promise2.fulfill()
        }
        wait(for: [promise2], timeout: 1)
        XCTAssertEqual(viewModel.stories, skeletonStories)
    }

    func testLoadStory() throws {
        let ids = [1, 8863, 3]
        let promise = XCTestExpectation()
        service.topStoryIds = ids
        viewModel.loadTopStories { error in
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1)
        XCTAssertNil(viewModel.stories[1].author)
        XCTAssertEqual(viewModel.stories[1].id, 8863)

        let story: Story = JSONLoader.load(filename: "story")!
        let promise2 = XCTestExpectation()
        service.item = story
        viewModel.loadStory(Story(id: 8863)) {
            promise2.fulfill()
        }
        wait(for: [promise2], timeout: 1)
        XCTAssertEqual(viewModel.stories[1].author, "dhouston")
        XCTAssertEqual(viewModel.stories[1].id, 8863)

        let storyDeleted: Story = JSONLoader.load(filename: "story_deleted")!
        let promise3 = XCTestExpectation()
        service.item = storyDeleted
        viewModel.loadStory(Story(id: 8863)) {
            promise3.fulfill()
        }
        wait(for: [promise3], timeout: 1)
        XCTAssertEqual(viewModel.stories.map { $0.id }, [1, 3])
    }
}
