//
//  TokenData.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/02/28.
//

import Foundation

struct TokenData: Codable {
    let token: String
    
    enum Codingkeys: String, CodingKey {
        case token = "token"
    }
}
