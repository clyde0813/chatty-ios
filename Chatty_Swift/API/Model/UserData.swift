//
//  UserData.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/01/24.
//

import Foundation

struct UserData: Codable {
    let username, token: String
    
    enum CodingKeys: String, CodingKey {
        case username
        
        case token
    }
}

enum APIError:Error {
    case http(ErrorData)
    
    case unknown
}

struct ErrorData: Codable {
    let error, status_code: String
    
    enum CodingKeys: String, CodingKey {
        case error
        
        case status_code
    }
}
