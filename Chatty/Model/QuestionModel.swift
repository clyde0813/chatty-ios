//
//  questionData.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/03/24.
//

import Foundation

struct QuestionModel: Codable  {
    var next, previous: Int?
    var results: [ResultDetail]
    
    enum CodingKeys : String, CodingKey {
        case next = "next"
        case previous = "previous"
        case results = "results"
    }
    
    
}

struct ResultDetail: Codable {
    let pk: Int
    let createdDate: String
    let answeredDate: String?
    //사용자
    let profile: Profile
    //글질문한사람 -> nil일시 익명
    let author: Profile?
    let content: String
    var answerContent: String?
    var refusalStatus : Bool
    var like: Int
    var likeStatus : Bool
    
    enum CodingKeys: String, CodingKey {
        case pk
        case createdDate = "created_date"
        case answeredDate = "answered_date"
        case profile, author, content
        case answerContent = "answer_content"
        case refusalStatus = "refusal_status"
        case like = "like"
        case likeStatus = "like_status"
    }
    
}

struct Profile: Codable ,Hashable{
    let username, profileName: String
    let profileImage, backgroundImage: String

    enum CodingKeys: String, CodingKey {
        case username
        case profileName = "profile_name"
        case profileImage = "profile_image"
        case backgroundImage = "background_image"
    }
}
