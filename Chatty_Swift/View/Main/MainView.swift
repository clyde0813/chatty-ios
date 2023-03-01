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
        if !UserDefaults.standard.bool(forKey: "isLoggedIn") {
            ContentView()
        } else {
            TabView (selection: $currentTab) {
                HomeView()
                    .tag(BottomTab.home)
                    .tabItem{
                        Image(systemName: "house")
                        Text("롬")}
                CommunityView()
                    .tag(BottomTab.community)
                    .tabItem{
                        Image(systemName: "message.badge.filled.fill")
                        Text("커뮤니티")}
                RankingView()
                    .tag(BottomTab.ranking)
                    .tabItem{
                        Image(systemName: "crown.fill")
                        Text("랭킹")}
                MyPageView()
                    .tag(BottomTab.mypage)
                    .tabItem{
                        Image(systemName: "person.crop.circle.fill")
                        Text("마이페이지")}
            }
            .accentColor(Color("Main Color"))
            .ignoresSafeArea(.all)
            .navigationBarHidden(true)
        }
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(UserVM())
    }
}
