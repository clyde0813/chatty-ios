//
//  questionData.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/03/24.
//

import Foundation

struct QuestionData: Codable {
    let next, previous: Int?
    let results: [ResultDetail]
}

struct ResultDetail: Codable {
    let pk: Int
    let nickname, content, createdDate, answerContent: String

    enum CodingKeys: String, CodingKey {
        case pk, nickname, content
        case createdDate = "created_date"
        case answerContent = "answer_content"
    }
}
