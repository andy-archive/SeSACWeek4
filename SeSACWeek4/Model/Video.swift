//
//  Video.swift
//  SeSACWeek4
//
//  Created by Taekwon Lee on 2023/08/17.
//

import Foundation

// MARK: - VideoList
struct VideoList: Codable {
    let documents: [Video]?
    let meta: Meta?
}

// MARK: - Document
struct Video: Codable {
    let author, datetime, thumbnail, title, url: String
    let playTime: Int

    enum CodingKeys: String, CodingKey {
        case author, datetime, thumbnail, title, url
        case playTime = "play_time"
    }
    
    var contents: String {
        return "\(author) | \(playTime)회\n\(datetime)"
    }
}

// MARK: - Meta
struct Meta: Codable {
    let isEnd: Bool
    let pageableCount, totalCount: Int

    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}
