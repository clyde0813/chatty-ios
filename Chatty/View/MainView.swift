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
    @EnvironmentObject var chattyVM: ChattyVM
    
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var currentTab : BottomTab = .home
    
    @State var logoutStatus : Bool = false
    
    @State private var shareView : Bool = false
    
    @State private var profileEditView : Bool = false
    
    @State private var profilePrivacyEditView : Bool = false
    
    @State private var profileView : Bool = false
    
    @State private var username : String = ""
    
    @State private var profile_name : String = ""
    
    @State private var profile_image : String = ""
    
    @State private var background_image : String = ""
    
    @State private var questiondata : ResultDetail?
        
    init(){
        UITabBar.appearance().backgroundColor = .white
    }
    
    var body: some View {
        if self.logoutStatus{
            IndexView()
        } else {
            NavigationStack{
                TabView (selection: $currentTab) {
                    TimelineView()
                        .tag(BottomTab.home)
                        .tabItem{
                            Image(systemName: "house.fill")
                            Text("홈")}
//                    CommunityView()
//                        .tag(BottomTab.community)
//                        .tabItem{
//                            Image(systemName: "message.fill")
//                            Text("커뮤니티")}
//                    RankingView()
//                        .tag(BottomTab.ranking)
//                        .tabItem{
//                            Image(systemName: "trophy.fill")
//                            Text("랭킹")}
                    MyPageView()
                        .tag(BottomTab.mypage)
                        .tabItem{
                            Image(systemName: "person.crop.circle.fill")
                            Text("마이페이지")}
                }
                .onReceive(chattyVM.logoutSuccess){
                    self.logoutStatus = true
                }
                .onReceive(chattyVM.shareViewPass){
                    self.username = chattyVM.username
                    self.profile_name = chattyVM.profile_name
                    self.profile_image = chattyVM.profile_image
                    self.background_image = chattyVM.background_image
                    self.questiondata = chattyVM.questiondata
                    self.shareView = true
                }
                .onReceive(chattyVM.profilePressed){
                    self.username = chattyVM.username
                    self.profileView = true
                }
                .onReceive(chattyVM.profileEditPressed){
                    self.profileEditView = true
                }
                .accentColor(Color.black)
                .navigationBarHidden(true)
                .navigationDestination(isPresented: $shareView) {
                    ChattyShareView(username: self.$username, profile_name: self.$profile_name, profile_image: self.$profile_image, background_image: self.$background_image, questiondata: self.$questiondata)
                }
                .navigationDestination(isPresented: $profileEditView){
                    ProfileEditView()
                }
            }
        }
    }
}



struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(ChattyVM())
    }
}



