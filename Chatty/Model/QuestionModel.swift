//
//  questionData.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/03/24.
//

import Foundation

struct QuestionModel: Codable {
    var next, previous: Int?
<<<<<<< HEAD
=======
    var profile : profile
>>>>>>> 6cfd2ca (1)
    var results: [ResultDetail]
    
}

struct ResultDetail: Codable {
    let pk: Int
    let createdDate: String
    let answeredDate: String?
    let profile: Profile
    let author: Profile?
    let content: String
    let answerContent: String?

    enum CodingKeys: String, CodingKey {
        case pk
        case createdDate = "created_date"
        case answeredDate = "answered_date"
        case profile, author, content
        case answerContent = "answer_content"
    }
}

struct Profile: Codable {
    let username, profileName: String
    let profileImage, backgroundImage: String

    enum CodingKeys: String, CodingKey {
        case username
        case profileName = "profile_name"
        case profileImage = "profile_image"
        case backgroundImage = "background_image"
    }
}
