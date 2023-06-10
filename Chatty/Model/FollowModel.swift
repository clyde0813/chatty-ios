//
//  FollowModel.swift
//  Chatty
//
//  Created by Hyeonho on 2023/06/11.
//

import Foundation

struct FollowModel : Codable{
    var next, previous: Int?
    var results: [ProfileModel]
}
