//
//  Item.swift
//  feed
//
//  Created by Rance Tsai on 10/2/20.
//

import Foundation

enum ItemType: String, Decodable {
    case job
    case story
    case comment
    case poll
    case pollopt
}

class Item: Decodable {
    let id: Int
    let isDeleted: Bool?
    let type: ItemType
    let author: String?
    let creationTime: Date?
    let isDead: Bool?
    let commentIds: [Int]?

    enum CodingKeys: String, CodingKey {
        case id
        case isDeleted = "deleted"
        case type
        case author = "by"
        case creationTime = "time"
        case isDead = "dead"
        case commentIds = "kids"
    }

    var isLoaded: Bool {
        creationTime != nil
    }

    var isHidden: Bool {
        isDeleted == true || isDead == true
    }

    init(id: Int, type: ItemType) {
        self.id = id
        isDeleted = nil
        self.type = type
        author = nil
        creationTime = nil
        isDead = nil
        commentIds = nil
    }
}
