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
    case unknown
}

class Item: Decodable {
    let id: Int
    let isDeleted: Bool?
    let type: ItemType
    let author: String?
    let creationTime: Date?
    let isDead: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case isDeleted = "deleted"
        case type
        case author = "by"
        case creationTime = "time"
        case isDead = "dead"
    }

    var isLoaded: Bool {
        creationTime != nil
    }

    var isHidden: Bool {
        isDeleted == true || isDead == true
    }

    init(
        id: Int,
        isDeleted: Bool? = nil,
        type: ItemType,
        author: String? = nil,
        creationTime: Date? = nil,
        isDead: Bool? = nil) {

        self.id = id
        self.isDeleted = isDeleted
        self.type = type
        self.author = author
        self.creationTime = creationTime
        self.isDead = isDead
    }
}
