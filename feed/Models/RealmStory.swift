//
//  RealmStory.swift
//  feed
//
//  Created by Rance Tsai on 10/5/20.
//

import Foundation
import RealmSwift

@objcMembers
final class RealmStory: Object {
    dynamic var id = 0
    dynamic var isDeleted = false
    dynamic var type = ItemType.unknown.rawValue
    dynamic var author: String?
    dynamic var creationTime: Date?
    dynamic var isDead: Bool = false
    dynamic var numberOfComments: Int = 0
    dynamic var score: Int = 0
    dynamic var title: String?
    dynamic var url: String?

    init(story: Story) {
        id = story.id
        isDeleted = story.isDeleted ?? false
        type = story.type.rawValue
        author = story.author
        creationTime = story.creationTime
        isDead = story.isDead ?? false
        numberOfComments = story.numberOfComments ?? 0
        score = story.score ?? 0
        title = story.title
        url = story.url?.absoluteString
    }

    required init() {
        super.init()
    }

    override class func primaryKey() -> String? { "id" }
}
