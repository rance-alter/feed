//
//  StoryTableViewCellViewModel.swift
//  feed
//
//  Created by Rance Tsai on 10/4/20.
//

import UIKit

protocol StoryTableViewCellViewModelProtocol {
    var isLoaded: Bool { get }
    var title: String { get }
    var subtitle: String { get }
}

struct StoryTableViewCellViewModel: StoryTableViewCellViewModelProtocol {
    let isLoaded: Bool
    let title: String
    let subtitle: String

    init(story: Story, now: Date = Date()) {
        isLoaded = story.creationTime != nil
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
