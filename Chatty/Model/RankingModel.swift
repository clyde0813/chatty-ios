//
//  RankingModel.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/04/20.
//

import Foundation

struct RankingModel: Codable {
    let ranking: [Ranking]
}

// MARK: - Ranking
struct Ranking: Codable {
    let username: String
    let profileName : String
    let profileImage: String
    let questionCount: Int

    enum CodingKeys: String, CodingKey {
        case username
        case profileName = "profile_name"
        case profileImage = "profile_image"
        case questionCount = "question_count"
    }
}

