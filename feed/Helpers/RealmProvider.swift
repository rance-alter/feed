//
//  RealmProvider.swift
//  feed
//
//  Created by Rance Tsai on 10/5/20.
//

import Foundation
import RealmSwift

protocol RealmProvidering {
    func realm() -> Realm
}

struct RealmProvider: RealmProvidering {
    func realm() -> Realm {
        return try! Realm()
    }
}
