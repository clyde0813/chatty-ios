//
//  TokenData.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/02/28.
//

import Foundation

struct TokenModel: Codable {
    let refresh, access: String
    
    enum Codingkeys: String, CodingKey {
        case refresh, access
    }
}
