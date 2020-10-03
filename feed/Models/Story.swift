//
//  Story.swift
//  feed
//
//  Created by Rance Tsai on 10/2/20.
//

import Foundation

final class Story: Item {
    let numberOfComments: Int?
    let score: Int?
    let title: String?
    let url: URL?

    enum CodingKeys: String, CodingKey {
        case numberOfComments = "descendants"
        case score
        case title
        case url
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        numberOfComments = try container.decodeIfPresent(Int.self, forKey: .numberOfComments)
        score = try container.decodeIfPresent(Int.self, forKey: .score)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        url = try container.decodeIfPresent(URL.self, forKey: .url)
        try super.init(from: decoder)
    }
}
