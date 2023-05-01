//
//  UserInfoResponse.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/02/28.
//

import Foundation

struct ProfileModel: Codable {
    let username, profile_name: String
    let userID, responseRate: Int
    let questionCount: QuestionCount
    let profileImage: String
    let backgroundImage: String
    let profileMessage: String?
    let follower, following: Int

    enum CodingKeys: String, CodingKey {
        case username = "username"
        case profile_name = "profile_name"
        case userID = "user_id"
        case responseRate = "response_rate"
        case questionCount = "question_count"
        case profileImage = "profile_image"
        case backgroundImage = "background_image"
        case profileMessage = "profile_message"
        case follower, following
    }
}

struct QuestionCount: Codable {
    let answered, unanswered, rejected: Int
}
