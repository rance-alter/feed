//
//  HackerNewsEndpoint.swift
//  feed
//
//  Created by Rance Tsai on 10/3/20.
//

import Foundation

enum HackerNewsEndpoint: String {
    case topStories = "topstories"
}

enum HackerNewsAPIVersion: String {
    case v0
}

extension HackerNewsEndpoint {
    private static let baseURL = URL(string: "https://hacker-news.firebaseio.com")!

    func url(_ version: HackerNewsAPIVersion = .v0) -> URL {
        Self.baseURL
            .appendingPathComponent(version.rawValue)
            .appendingPathComponent(self.rawValue)
    }
}
