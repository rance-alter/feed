//
//  HackerNewsEndpoint.swift
//  feed
//
//  Created by Rance Tsai on 10/3/20.
//

import Foundation

private let baseURL = URL(string: "https://hacker-news.firebaseio.com")!

enum HackerNewsAPIVersion: String {
    case v0
}

protocol HackerNewsEndpointProtocol {
    func url(_ version: HackerNewsAPIVersion) -> URL
}

extension HackerNewsEndpointProtocol {
    func url(_ version: HackerNewsAPIVersion = .v0) -> URL {
        url(version)
    }
}

enum HackerNewsEndpoint: String, HackerNewsEndpointProtocol {
    case topStories = "topstories"

    func url(_ version: HackerNewsAPIVersion = .v0) -> URL {
        baseURL
            .appendingPathComponent(version.rawValue)
            .appendingPathComponent(self.rawValue)
    }
}

struct ItemEndpoint: HackerNewsEndpointProtocol {
    let id: Int

    func url(_ version: HackerNewsAPIVersion) -> URL {
        baseURL
            .appendingPathComponent(version.rawValue)
            .appendingPathComponent("item")
            .appendingPathComponent("\(id).json")
    }
}
