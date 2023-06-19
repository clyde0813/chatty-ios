import SwiftUI



enum BottomTab {
    case home, community, ranking, mypage
}

struct MainView: View {
    @EnvironmentObject var chattyVM: ChattyVM
    
    @Environment(\.dismiss) var dismissgit
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var currentTab : BottomTab = .home
    
    @State var logoutStatus : Bool = false
        
    init(){
        UITabBar.appearance().backgroundColor = .white
    }
    
    var body: some View {
        if self.logoutStatus{
            IndexView()
        } else {
                TabView (selection: $currentTab) {
                    TimelineView()
                        .tag(BottomTab.home)
                        .tabItem{
                            Image(systemName: "house.fill")
                            Text("홈")
                        }
                        
                    
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
                .navigationBarHidden(true)
                .onReceive(chattyVM.logoutSuccess){
                    self.logoutStatus = true
                }
                .accentColor(Color.black)
                .onChange(of: currentTab) { tab in
                    if tab == .home {
                        NavigationUtil.popToRootView()
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



