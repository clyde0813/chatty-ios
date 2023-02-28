//
//  RankingView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/02/23.
//

import SwiftUI

struct RankingView: View {
    var body: some View {
        Color.red.edgesIgnoringSafeArea(.all)
            .tag(BottomTab.ranking)
            .tabItem{
                Image(systemName: "crown.fill")
                Text("랭킹")
            }
    }
}

struct RankingView_Previews: PreviewProvider {
    static var previews: some View {
        RankingView()
    }
}
