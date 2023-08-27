import SwiftUI
import Combine


enum BottomTab  {
    case home, community, ranking, mypage
}

enum ShareLink : Hashable {
    case profileView(String)
    case editProfileView
}


struct MainView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var currentTab : BottomTab = .home
    
    @State var clickTab = false
    
    @State var doubleClickTab = false
    
    @StateObject var MainVM = MainTabViewVM()
    
    init(){
        UITabBar.appearance().backgroundColor = .white
    }
    
    var body: some View {
        
        var handler : Binding<BottomTab> { Binding(
            get : {self.currentTab},
            set : {
                if $0 == self.currentTab {
                    print("onClick myTab!")
                    clickTab = true
                }
                currentTab = $0
                
            }
        )}
        
        
        TabView (selection: handler) {
            
            if let currentUser = MainVM.currentUser {
                TimelineView(user: currentUser, clickTab: $clickTab, doubleClickTab : $doubleClickTab)
                    .tabItem{
                        Image(systemName: "house.fill")
                        Text("홈")
                    }
                    .tag(BottomTab.home)
            }
            
            RankingView(clickTab: $clickTab,doubleClickTab : $doubleClickTab)
                .tabItem{
                    Image(systemName: "trophy.fill")
                    Text("랭킹")
                }
                .tag(BottomTab.ranking)
            
            MyPageView(clickTab: $clickTab, doubleClickTab: $doubleClickTab)
                .tabItem{
                    Image(systemName: "person.crop.circle.fill")
                    Text("마이페이지")
                }
                .tag(BottomTab.mypage)
            
            //                    CommunityView()
            //                        .tag(BottomTab.community)
            //                        .tabItem{
            //                            Image(systemName: "message.fill")
            //                            Text("커뮤니티")}
            
        }
        .onTapGesture(count: 2) {
            doubleClickTab.toggle()
        }
        .navigationBarHidden(true)
        .accentColor(Color.black)

            
        
    }
    
}



