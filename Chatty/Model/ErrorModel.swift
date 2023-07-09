//
//  ErrorModel.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/04/04.
//

import Foundation

struct ErrorModel: Codable, Error {
    let error : String?
    let status_code : Int?
}
