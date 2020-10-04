//
//  RealTestProvider.swift
//  feedTests
//
//  Created by Rance Tsai on 10/5/20.
//

import Foundation
import RealmSwift
@testable import feed

struct RealTestProvider: RealmProvidering {
    private let config: Realm.Configuration

    init(config: Realm.Configuration = Realm.Configuration(inMemoryIdentifier: "test")) {
        self.config = config
    }

    func realm() -> Realm {
        return try! Realm(configuration: config)
    }
}
