//
//  CommunityView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/02/23.
//

import SwiftUI

struct CommunityView: View {
    var body: some View {
        Color.red.edgesIgnoringSafeArea(.all)
            .tag(BottomTab.community)
            .tabItem{
                Image(systemName: "message.badge.filled.fill")
                Text("커뮤니티")
            }
    }
}

struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView()
    }
}
