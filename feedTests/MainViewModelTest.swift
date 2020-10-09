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
        service.dataSource = nil
    }

    func testLoadStories() throws {
        let ids = [Int](0 ..< 40)
        let promise = XCTestExpectation()
        let dataSource = HackerNewsServiceMockDataSource()
        var nextID: Int?
        dataSource.topStoryIDs = ids
        dataSource.itemMap = ids.reduce(into: [:]) {
            $0[$1] = Story(id: $1)
        }
        service.dataSource = dataSource
        viewModel.loadTopStories(id: nil) { id, error in
            nextID = id
            XCTAssertEqual(id, 20)
            XCTAssertNil(error)
            let realm = self.realmProvider.realm()
            let realmStories = realm.objects(RealmStory.self)
            XCTAssertEqual(realmStories.count, 20)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1)
        XCTAssertEqual(viewModel.numberOfItems, 20)
        XCTAssertEqual(
            (0 ..< 20).map { viewModel.story(at: $0) },
            (0 ..< 20).map { Story(id: $0) })

        let promise2 = XCTestExpectation()
        viewModel.loadTopStories(id: nextID) { id, error in
            XCTAssertNil(id)
            XCTAssertNil(error)
            let realm = self.realmProvider.realm()
            let realmStories = realm.objects(RealmStory.self)
            XCTAssertEqual(realmStories.count, 40)
            promise2.fulfill()
        }
        wait(for: [promise2], timeout: 1)
        XCTAssertEqual(viewModel.numberOfItems, 40)
        XCTAssertEqual(
            (0 ..< 40).map { viewModel.story(at: $0) },
            (0 ..< 40).map { Story(id: $0) })
    }
}
