//
//  JSONLoader.swift
//  feedTests
//
//  Created by Rance Tsai on 10/4/20.
//

import Foundation

final class JSONLoader {
    static func load<T: Decodable>(
        filename: String,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .secondsSince1970) -> T? {

        let bundle = Bundle(for: Self.self)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy

        return try? bundle.url(forResource: filename, withExtension: "json")
            .flatMap { try Data(contentsOf: $0) }
            .map { try decoder.decode(T.self, from: $0) }
    }
}
