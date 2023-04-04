//
//  questionResponse.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/03/08.
//

import Foundation

struct QuestionResponse: Codable {
    let next, previous: Int?
    let results: [Result]
}

struct Result: Codable {
    let pk: Int
    let nickname, content, createdDate, answerContent: String

    enum CodingKeys: String, CodingKey {
        case pk, nickname, content
        case createdDate = "created_date"
        case answerContent = "answer_content"
    }
}
