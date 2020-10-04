//
//  StoryTableViewCellViewModel.swift
//  feed
//
//  Created by Rance Tsai on 10/4/20.
//

import UIKit

protocol StoryTableViewCellViewModelProtocol {
    var title: String { get }
    var subtitle: String { get }
}

struct StoryTableViewCellViewModel: StoryTableViewCellViewModelProtocol {
    let title: String
    let subtitle: String

    init(story: Story, now: Date = Date()) {
        title = story.title ?? "No title"

        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let timeText = story.creationTime.flatMap {
            " " + formatter.localizedString(for: $0, relativeTo: now)
        } ?? ""

        subtitle = "\(story.score ?? 0) points by \(story.author ?? "unknown user")"
            + timeText
            + " | \(story.numberOfComments ?? 0) comments"
    }
}
