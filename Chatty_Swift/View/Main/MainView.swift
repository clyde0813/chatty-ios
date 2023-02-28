//
//  MainView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/02/23.
//

import SwiftUI

enum BottomTab {
    case home, community, ranking, mypage
}

struct MainView: View {
    @EnvironmentObject var userVM: UserVM
    
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var currentTab : BottomTab = .home
        
    init(){
        UITabBar.appearance().backgroundColor = .white
    }
    
    var body: some View {
        TabView (selection: $currentTab) {
            HomeView()
            CommunityView()
            RankingView()
            MyPageView()
        }
        .accentColor(Color("Main Color"))
        .ignoresSafeArea(.all)
        .navigationBarHidden(true)
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(UserVM())
    }
}
