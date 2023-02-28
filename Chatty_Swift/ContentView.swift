//
//  ContentView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2022/12/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        if !UserDefaults.standard.bool(forKey: "isLoggedIn") {
            IndexView()
        } else {
            MainView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(UserVM())
    }
}
