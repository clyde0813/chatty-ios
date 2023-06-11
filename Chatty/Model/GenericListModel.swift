//
//  GenericListModel.swift
//  Chatty
//
//  Created by Clyde on 2023/06/11.
//

import Foundation

struct GenericListModel<T: Codable>: Codable {
    var next, previous: Int?
    var results: [T]
}
