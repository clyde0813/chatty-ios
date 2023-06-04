import SwiftUI
import Kingfisher


enum Timeline_Hot_Tab {
    case timeline,hotQuestion
}

struct TimelineView: View {
    
    @State var currentTab : Timeline_Hot_Tab =  .timeline
    @StateObject var profileVM = ProfileVM()
    
    
    @State var profile_image = ""
    
//    @Binding var currentTab : BottomTab
    var body: some View {
        VStack{
            //MARK: - 상단 navBar & Tabbar  -2023.06.06 신현호-
            VStack{
                navBar
                tabChangeBar
            }
            .background(Rectangle()
                .fill(Color.white)
                .shadow(color: Color("Shadow Button"), radius: 3, x: 0, y: 6)
            )
            ScrollView{
                LazyVStack(spacing: 16){
                    Text("카드들을 넣어야하는데 유저정보가 필요해 슈밤")
                    Text("그런데 지금이건 새로만든거라 뷰모델을 건드리기쫌 그래")
                    Text("그럼 그냥 MainView에서 EnviromentObject로")
                }
            }
            .background(Color("Background inner"))
        }
        .onAppear(perform: {
            self.initTimelineView()
        })        .onReceive(profileVM.$profileModel) { userInfo in
            guard let user = userInfo else { return }
            self.profile_image = user.profileImage
        }

        
    }
    
    func initTimelineView() {
        profileVM.profileGet(username: KeyChain.read(key: "username")!)
    }
    
}


extension TimelineView {
    var navBar : some View {
        HStack{
            NavigationLink {
                ProfileView(username: .constant(KeyChain.read(key: "username")!), isOwner: true)
            } label: {
                //URL(string:"\(profile_image)")
                KFImage(URL(string: self.profile_image))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 40,height: 40)
            }
            Spacer()
            Image("Logo Small")
                .resizable()
                .scaledToFill()
                .frame(width: 32, height: 32)
            Spacer()
            Image(systemName: "magnifyingglass")
                .fontWeight(.bold)
                .font(.system(size: 28))
                .foregroundColor(Color("Main Secondary"))
        }
        .padding(.horizontal, 16)
        .frame(height: 60)
    }
    
    var tabChangeBar : some View {
        HStack(spacing: 20){
            Spacer()
            ZStack(alignment: .bottom){
                Button(action: {
                    currentTab = .timeline
                }){
                    if currentTab == .timeline {
                        VStack(alignment: .center, spacing: 0){
                            Text("타임라인")
                                .font(Font.system(size: 16, weight: .bold))
                                .accentColor(.black)
                                .padding(.bottom, 9)
                            Rectangle()
                                .fill(Color("Main Secondary"))
                                .frame(width: 50, height: 3)
                        }
                    } else {
                        Text("타임라인")
                            .font(Font.system(size: 16, weight: .semibold))
                            .foregroundColor(Color.gray)
                            .padding(.bottom, 12)
                    }
                }
                .accentColor(.black)
            }
            Spacer()
            ZStack(alignment: .bottom){
                Button(action: {
                    currentTab = .hotQuestion
                }){
                    if currentTab == .hotQuestion {
                        VStack(alignment: .center, spacing: 0){
                            Text("지금 핫한 질문")
                                .font(Font.system(size: 16, weight: .bold))
                                .accentColor(.black)
                                .padding(.bottom, 9)
                            Rectangle()
                                .fill(Color("Main Secondary"))
                                .frame(width: 50, height: 3)
                        }
                    } else {
                        Text("지금 핫한 질문")
                            .font(Font.system(size: 16, weight: .semibold))
                            .foregroundColor(Color.gray)
                            .padding(.bottom, 12)
                    }
                }
                .accentColor(.black)
            }
            Spacer()
        }
        .padding(.top,10)
    }
}


struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
    }
}
