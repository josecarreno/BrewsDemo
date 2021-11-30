//
//  Beer.swift
//  BeersDemo
//

import Foundation

struct Beer: Equatable, Hashable {
    var name: String
    var tagline: String
    var description: String
    var image_url: String
}

extension Beer: Decodable {

    enum CodingKeys: String, CodingKey {
        case name
        case tagline
        case description
        case image_url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        tagline = try container.decode(String.self, forKey: .tagline)
        description = try container.decode(String.self, forKey: .description)
        image_url = try container.decode(String.self, forKey: .image_url)
    }
}
