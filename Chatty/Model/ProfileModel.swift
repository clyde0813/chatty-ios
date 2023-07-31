//
//  UserInfoResponse.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/02/28.
//

import Foundation

struct ProfileModel: Codable,Hashable {
    var username, profile_name: String
    let userID, responseRate: Int
    let questionCount: QuestionCount
    var profileImage: String
    var backgroundImage: String
    var profileMessage: String?
    var follower, following: Int
    let views: Int
    var followState : Bool
    var blockState : Bool
    var rankState : Bool

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
        case views
        case followState = "follow_status"
        case blockState = "block_state"
        case rankState = "ranking_status"
    }
}

struct QuestionCount: Codable ,Hashable{
    let answered, unanswered, rejected: Int
}
