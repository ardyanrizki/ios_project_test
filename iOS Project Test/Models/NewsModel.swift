//
//  NewsModel.swift
//  iOS Project Test
//
//  Created by Ardyan on 22/10/21.
//

import Foundation

struct News: Codable {
    let results: [Article]
}

struct Article: Codable {
    let source: String
    let id: Int?
    let title: String
    let abstract: String?
    let url: String?
    let published_date: String
    let media: [Media?]
}

struct Media: Codable, Identifiable {
    var id = UUID()
    let type: String?
    let mediaMetadata: [MediaMetadata]?
    
    enum CodingKeys: String, CodingKey {
        case type
        case mediaMetadata = "media-metadata"
    }
}


struct MediaMetadata: Codable {
    let url: String?
    let format: String?
}
