//
//  Chatty_SwiftApp.swift
//  Chatty_Swift
//
//  Created by Clyde on 2022/12/21.
//

import SwiftUI

@main
struct Chatty_SwiftApp: App {
    var body: some Scene {
        WindowGroup {
            IndexView().environmentObject(UserVM())
        }
    }
}
