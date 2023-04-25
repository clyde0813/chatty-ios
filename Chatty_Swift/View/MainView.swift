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
    
    @State private var profileView : Bool = false
    
    @State private var username : String = ""
        
    init(){
        UITabBar.appearance().backgroundColor = .white
    }
    
    var body: some View {
        if self.logoutStatus{
            IndexView()
        } else {
            NavigationStack{
                TabView (selection: $currentTab) {
                    ProfileView(username: .constant(KeyChain.read(key: "username")!), isOwner: true, currentTab: .constant(currentTab))
                        .tag(BottomTab.home)
                        .tabItem{
                            Image(systemName: "house.fill")
                            Text("홈")}
                    CommunityView()
                        .tag(BottomTab.community)
                        .tabItem{
                            Image(systemName: "message.fill")
                            Text("커뮤니티")}
                    RankingView()
                        .tag(BottomTab.ranking)
                        .tabItem{
                            Image(systemName: "trophy.fill")
                            Text("랭킹")}
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
                    ChattyShareView(username: chattyVM.username, profile_name: chattyVM.profile_name, profile_image: chattyVM.profile_image, questiondata: chattyVM.questiondata!)
                }
                .navigationDestination(isPresented: $profileView) {
                    if KeyChain.read(key: "username")! == self.username{
                        ProfileView(username: self.$username, isOwner: true, currentTab: .constant(currentTab))
                    } else {
                        ProfileView(username: self.$username, isOwner: false, currentTab: .constant(currentTab))
                    }
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



