//
//  Video.swift
//  ShareMusic
//
//  Created by Mohammed on 7/28/20.
//  Copyright © 2020 Mohammed. All rights reserved.
//

import Foundation

class Video: Codable {
    
    let kind, etag: String?
    let id: ID?
    let snippet: Snippet?
    
    init(kind: String?, etag: String?, id: ID?, snippet: Snippet?) {
        self.kind = kind
        self.etag = etag
        self.id = id
        self.snippet = snippet
    }
    
}


class ID: Codable {
    let kind, videoID: String?
    
    enum CodingKeys: String, CodingKey {
        case kind
        case videoID = "videoId"
    }
    
    init(kind: String?, videoID: String?) {
        self.kind = kind
        self.videoID = videoID
    }
}

class Snippet: Codable {
    let publishedAt: String?
    let channelID, title, snippetDescription: String?
    let thumbnails: Thumbnails?
    let channelTitle, liveBroadcastContent: String?
    
    enum CodingKeys: String, CodingKey {
        case publishedAt
        case channelID = "channelId"
        case title
        case snippetDescription = "description"
        case thumbnails, channelTitle, liveBroadcastContent
    }
    
    init(publishedAt: String?,channelID: String?, title: String?, snippetDescription: String?, thumbnails: Thumbnails?, channelTitle: String?, liveBroadcastContent: String?) {
        self.publishedAt = publishedAt
        self.channelID = channelID
        self.title = title
        self.snippetDescription = snippetDescription
        self.thumbnails = thumbnails
        self.channelTitle = channelTitle
        self.liveBroadcastContent = liveBroadcastContent
    }
}

// MARK: - Thumbnails
class Thumbnails: Codable {
    let thumbnailsDefault, medium, high: Default?
    
    enum CodingKeys: String, CodingKey {
        case thumbnailsDefault = "default"
        case medium, high
    }
    
    init(thumbnailsDefault: Default?, medium: Default?, high: Default?) {
        self.thumbnailsDefault = thumbnailsDefault
        self.medium = medium
        self.high = high
    }
}

// MARK: - Default
class Default: Codable {
    let url: String?
    let width, height: Int?
    
    init(url: String?, width: Int?, height: Int?) {
        self.url = url
        self.width = width
        self.height = height
    }
}
