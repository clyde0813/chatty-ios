import SwiftUI
import Kingfisher
import UIKit
import Combine

enum Timeline_Hot_Tab {
    case timeline,hotQuestion
}

enum StackPath : Hashable{
    case profileView(String)
    case searchView
    case DetailView
    case FollowView(String,followTab)
    case profileEditView
}

struct TimelineView: View {
    @StateObject var timelineVM = TimeLineVM()
    @State var showMsg = false
    @State var msg = ""
    @State var isClickedQuestion = false
    @State var currentTab : Timeline_Hot_Tab =  .timeline
    @State var path = NavigationPath()
    var currentUser : ProfileModel
    
    @Binding var clickTab: Bool
    @Binding var doubleClickTab : Bool
    
    @Namespace var topID
    
    init(user: ProfileModel, clickTab: Binding<Bool>, doubleClickTab : Binding<Bool>){
        currentUser = user
        self._clickTab = clickTab
        self._doubleClickTab = doubleClickTab
    }
    
    private var cancellable = Set<AnyCancellable>()
    
    var body: some View {
        NavigationStack(path : $path){
            ZStack(alignment: .bottomTrailing){
                //MARK: - 상단 navBar & Tabbar  -2023.06.03 신현호-
                VStack{
                    navBar
                    tabChangeBar
                        .background(Rectangle()
                            .fill(Color.white)
                            .shadow(color: Color("Shadow Button"), radius: 3, x: 0, y: 6)
                        )
                    timelineList
                }
                .blur(radius: isClickedQuestion ? 2 : 0)
                
                if isClickedQuestion {
                    BlurView()
                        .ignoresSafeArea()
                        .onTapGesture {
                            isClickedQuestion.toggle()
                        }
                        .background(Color("Background Overlay"))
                        .opacity(0.7)
                        .toolbar(.hidden ,for: .tabBar)
                }
                questionButton
                
                if showMsg {
                    ProfileErrorView(msg: msg)
                }
            }
            .onAppear{
                print("run Appear")
                timelineVM.timelineData = nil
                timelineVM.currentPage = 1
                timelineVM.subscribe()
                timelineVM.timelineGet()
            }
            .onDisappear{
                timelineVM.currentPage = nil
                timelineVM.timelineData = nil
                timelineVM.cancel()
                print("timelineView Disappear")
            }
            .onReceive(ChattyEventManager.share.showAlter){ result in
                msg = result
                showMsg = true
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                    showMsg = false
                }
            }
            .toolbar(.hidden)
            .navigationDestination(for: StackPath.self){ result in
                switch result {
                case .profileView(let username):
                    ProfileView(username: username, clickTab: $clickTab)
                case .searchView:
                    UserSearchView()
                case .DetailView:
                    QuestionDetailView()
                case .FollowView(let username, let followTab):
                    FollowView(username: username, followTab: followTab)
                case .profileEditView:
                    ProfileEditView()
                }
            }
            .onChange(of: doubleClickTab) { newValue in
                path = .init()
            }
        }
        
        
    }
}


//MARK: - Content
extension TimelineView {
    var navBar : some View {
        HStack{
            NavigationLink(value: StackPath.profileView(currentUser.username)) {
                KFImage(URL(string: currentUser.profileImage))
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
            
            NavigationLink(value: StackPath.searchView) {
                Image(systemName: "magnifyingglass")
                    .fontWeight(.semibold)
                    .font(.system(size: 28))
                    .foregroundColor(Color("Main Secondary"))
            }

            

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
            //            ZStack(alignment: .bottom){
            //                Button(action: {
            //                    currentTab = .hotQuestion
            //                }){
            //                    if currentTab == .hotQuestion {
            //                        VStack(alignment: .center, spacing: 0){
            //                            Text("지금 핫한 질문")
            //                                .font(Font.system(size: 16, weight: .bold))
            //                                .accentColor(.black)
            //                                .padding(.bottom, 9)
            //                            Rectangle()
            //                                .fill(Color("Main Secondary"))
            //                                .frame(width: 50, height: 3)
            //                        }
            //                    } else {
            //                        Text("지금 핫한 질문")
            //                            .font(Font.system(size: 16, weight: .semibold))
            //                            .foregroundColor(Color.gray)
            //                            .padding(.bottom, 12)
            //                    }
            //                }
            //                .accentColor(.black)
            //            }
            //            Spacer()
        }
        .padding(.top,10)
    }
    
    var timelineList : some View {
        GeometryReader{ proxy in
            ScrollViewReader { scrollProxy in
                ScrollView(showsIndicators: false){
                    Text("")
                        .frame(width: 0,height: 0)
                        .opacity(0)
                        .id(topID)
                    if timelineVM.timelineData == nil {
                        VStack{
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .frame(width: proxy.size.width)
                    }
                    else {
                        if timelineVM.timelineData?.results.isEmpty == true {
                            VStack(alignment: .center){
                                VStack(spacing: 0){
                                    Text("더 많은 친구를 팔로우하여 소식을 받아보세요!")
                                        .font(.system(size: 16, weight: .none))
                                        .padding(.bottom, 13)
                                    Button(action:{
                                        UIPasteboard.general.string = "chatty.kr/\(currentUser.username)"
                                        ChattyEventManager.share.showAlter.send("복사 완료!")
                                    }){
                                        Text("내 프로필 링크 복사하기")
                                            .font(.system(size:16, weight: .bold))
                                            .frame(height: 40)
                                            .frame(width: 194)
                                            .foregroundColor(Color.white)
                                            .background(
                                                Capsule()
                                                    .fill( LinearGradient(gradient: Gradient(colors: [Color("MainGradient1"), Color("MainGradient2"),Color("MainGradient3")]), startPoint: .trailing, endPoint: .leading))
                                            )
                                    }
                                }
                                .padding(.top, 80)
                            }
                            .frame(width: proxy.size.width)
                            .frame(maxHeight: .infinity)
                        }
                        else{
                            LazyVStack(spacing: 16){
                                ForEach(Array((timelineVM.timelineData?.results ?? []).enumerated()), id:\.element.pk){ index, questiondata in
                                    ResponsedCard(width: getWindowWidth()-32, chatty: questiondata,currentTab: PostTab.responsedTab)
                                        .onAppear{
                                            timelineVM.checkNextPage(data: questiondata)
                                        }
                                    
                                    if index % 4 == 0 && index != 0 {
                                        AdBannerView(bannerID: "ca-app-pub-3017845272648516/7121150693", width: proxy.size.width)
                                    }
                                }
                            }
                            .padding(.top, 10)
                        }
                    }

                    //MARK: - 2023.06.21 - 신현호
                    // 아직은 기능이없어서 주석처리
                    //                LazyVStack(spacing: 16){
                    //                    if let timelineList = questionVM.questionModel?.results{
                    //                        ForEach(timelineList, id:\.pk){ questiondata in
                    //                            ResponsedCard(width:proxy.size.width-32, questiondata: questiondata, eventVM : eventVM)
                    //                                .onAppear{
                    //                                    callNextTimeline(questiondata: questiondata)
                    //                                }
                    //                        }
                    //                    }
                    //                }
                    //                .padding(.top, 10)
                }
                .onChange(of: clickTab) { tap in
                    if tap{
                        withAnimation {
                            scrollProxy.scrollTo(topID)
                            clickTab = false
                        }

                    }
                }
            }
            .background(Color("Background inner"))
            // 2023.06.06 Clyde 높이 제한 추가
//            .frame(height: proxy.size.height)
            .frame(maxHeight: .infinity)
            .refreshable {
                timelineVM.timelineData = nil
                timelineVM.currentPage = 1
                timelineVM.timelineGet()
            }

        }
        
        
    }
    
    var questionButton : some View {
        VStack(alignment: .trailing){
            if isClickedQuestion {
                VStack(alignment: .trailing){
                    NavigationLink(value: StackPath.DetailView) {
                        HStack{
                            Image(systemName: "plus")
                            Text("다른 친구에게")
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical,14)
                        .background(.white)
                        .foregroundColor(Color("Main Primary"))
                        .clipShape(RoundedRectangle(cornerRadius: 99))
                        .shadow(color: Color("Shadow Button"), radius: 5, x: 0, y: 6)
                        .font(Font.system(size: 16, weight: .bold))
                    }

                    //MARK: - 2023.06.21 - 신현호
                    // 아직은 기능이없어서 주석처리
                    //                    Button {
                    //                        print("!!")
                    //                    } label: {
                    //                        HStack{
                    //                            Image(systemName: "plus")
                    //                            Text("최근 질문한 친구에게")
                    //                        }
                    //                        .padding(.horizontal, 16)
                    //                        .padding(.vertical,14)
                    //                        .background(Color("Main Primary"))
                    //                        .foregroundColor(.white)
                    //                        .clipShape(RoundedRectangle(cornerRadius: 99))
                    //                        .shadow(color: Color("Shadow Button"), radius: 5, x: 0, y: 6)
                    //                        .font(Font.system(size: 16, weight: .bold))
                    //                    }
                }
                .padding([.bottom, .trailing], 16)
            }
            else{
                Button {
                    withAnimation {
                        isClickedQuestion = true
                    }
                } label: {
                    NewQuestionButton()
                        .padding([.bottom, .trailing], 16)
                }
            }
        }
    }
}

//MARK: - methods
extension TimelineView{
    func getWindowWidth() -> CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let mainWindow = windowScene.windows.first else {
                    return 0
                }
        
        let windowWidth = mainWindow.frame.width
        return windowWidth
    }
}
