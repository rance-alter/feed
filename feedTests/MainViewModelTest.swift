//
//  MainViewModelTest.swift
//  feedTests
//
//  Created by Rance Tsai on 10/4/20.
//

import XCTest
import RealmSwift
@testable import feed

private enum SomeError: Error {
    case some
}

final class MainViewModelTest: XCTestCase {
    private let service = HackerNewsServiceMock()
    private let realmProvider = RealTestProvider()

    private lazy var viewModel: MainViewModel = {
        MainViewModel(service: self.service, realmProvider: self.realmProvider)
    }()

    override func setUpWithError() throws {
        service.topStoryIds = []
        service.item = nil
        service.error = nil
    }

    func testLoadStories() throws {
        let ids = [1, 2, 3]
        let realm = realmProvider.realm()
        let skeletonStories = ids.map { Story(id: $0) }
        let promise = XCTestExpectation()
        service.topStoryIds = ids
        viewModel.loadTopStories { error in
            XCTAssertNil(error)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1)
        XCTAssertEqual(viewModel.numberOfItems, ids.count)
        XCTAssertEqual((0 ..< ids.count).map { viewModel.story(at: $0) }, skeletonStories)
        let realmStories = realm.objects(RealmStory.self)
        XCTAssertEqual(realmStories.count, 3)

        let promise2 = XCTestExpectation()
        service.error = SomeError.some
        viewModel.loadTopStories { error in
            XCTAssertEqual(error as? SomeError, SomeError.some)
            promise2.fulfill()
        }
        wait(for: [promise2], timeout: 1)
        XCTAssertEqual(viewModel.numberOfItems, ids.count)
        XCTAssertEqual((0 ..< ids.count).map { viewModel.story(at: $0) }, skeletonStories)
    }

    func testLoadStory() throws {
        let ids = [1, 8863, 3]
        let realm = realmProvider.realm()
        let promise = XCTestExpectation()
        service.topStoryIds = ids
        viewModel.loadTopStories { error in
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1)
        XCTAssertNil(viewModel.story(at: 1)?.author)
        XCTAssertEqual(viewModel.story(at: 1)?.id, 8863)

        let story: Story = JSONLoader.load(filename: "story")!
        let promise2 = XCTestExpectation()
        service.item = story
        viewModel.loadStory(Story(id: 8863)) { result in
            switch result {
            case let .success(story):
                XCTAssertEqual(story.author, "dhouston")
                XCTAssertEqual(story.id, 8863)
            case .failure:
                XCTFail()
            }
            promise2.fulfill()
        }
        wait(for: [promise2], timeout: 1)
        XCTAssertEqual(viewModel.story(at: 1)?.author, "dhouston")
        XCTAssertEqual(viewModel.story(at: 1)?.id, 8863)
        let realmStory = realm.objects(RealmStory.self).filter("id = 8863").first
        XCTAssertEqual(realmStory?.author, "dhouston")
        XCTAssertEqual(realmStory?.id, 8863)

        let storyDeleted: Story = JSONLoader.load(filename: "story_deleted")!
        let promise3 = XCTestExpectation()
        service.item = storyDeleted
        viewModel.loadStory(Story(id: 8863)) { result in
            switch result {
            case .success:
                XCTFail()
            case let .failure(error):
                XCTAssertEqual(error as? MainViewModelError, MainViewModelError.hiddenItem)
            }
            promise3.fulfill()
        }
        wait(for: [promise3], timeout: 1)
        XCTAssertEqual(viewModel.numberOfItems, 2)
        let realmStories = realm.objects(RealmStory.self)
        XCTAssertEqual(realmStories.count, 2)
    }
}
