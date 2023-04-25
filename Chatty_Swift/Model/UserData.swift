//
//  UserData.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/01/24.
//

import Foundation

struct UserData: Codable {
    let username, refresh_token, access_token: String
    
    enum CodingKeys: String, CodingKey {
        case username, refresh_token, access_token
    }
}
