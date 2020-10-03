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
}
