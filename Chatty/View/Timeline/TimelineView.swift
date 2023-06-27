import SwiftUI
import Kingfisher
import UIKit

enum Timeline_Hot_Tab {
    case timeline,hotQuestion
}

struct TimelineView: View {
    
    @State var currentTab : Timeline_Hot_Tab =  .timeline
    @StateObject var profileVM = ProfileVM()
    @StateObject var questionVM = QuestionVM()
    @StateObject var eventVM = ChattyEventVM()
    @State var profile_image = ""
    @State var isClickedQuestion = false
    @State var currentPage = 1
    
    @State var copyButtonPressed = false
    
    @State var reportSuccess = false
    
    //    @StateObject var nativeAds = NativeVM()
    
    @State var showMySheet = false
    
    @State var showOtherUserSheet = false
    
    @State var isTimelineEmpty = true
    
    @State var isProgress = true
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing){
                VStack{
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
                    
                }
                
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
                
                if reportSuccess {
                    ProfileErrorView(msg: "신고 접수가 완료되었습니다!")
                }
                
            }
            .navigationBarHidden(true)
        }
        .onAppear(perform: {
            //MARK: - 광고초기화
            //                googleAdsVM.refreshAd()
            //                nativeAds.refreshAd()
            self.initTimelineView()
        })
        .onReceive(profileVM.$profileModel) { userInfo in
            guard let user = userInfo else { return }
            self.profile_image = user.profileImage
        }
        .onReceive(eventVM.mySheetPublisher){
            showMySheet = true
        }
        .onReceive(eventVM.otherUserSheetPublisher){
            showOtherUserSheet = true
        }
        .sheet(isPresented: $showMySheet, onDismiss: {showMySheet = false}) {
            QuestionOption(eventVM: eventVM)
                .presentationDetents([.fraction(0.4)])
        }
        .sheet(isPresented: $showOtherUserSheet, onDismiss: {showOtherUserSheet = false}) {
            QuestionOption(eventVM: eventVM)
                .presentationDetents([.fraction(0.2)])
        }
        .onReceive(eventVM.reportPublisher){
            questionVM.questionReport(question_id: eventVM.data?.pk ?? 0)
        }
        .onReceive(questionVM.reportSuccess){
            self.reportSuccess = true
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                self.reportSuccess = false
            }
        }
        
    }
    
    
    
    
    
}

//MARK: - Methods
extension TimelineView {
    
    
    func initTimelineView() {
        print("init")
        questionVM.questionModel = nil
        self.currentPage = 1
        profileVM.profileGet(username: KeyChain.read(key: "username")!)
        questionVM.timelineGet(page: self.currentPage)

    }
    
    func callNextTimeline(questiondata : ResultDetail){
        
        if questionVM.questionModel?.results.isEmpty == false && questionVM.questionModel?.next != nil && questiondata.pk == questionVM.questionModel?.results.last?.pk{
            print("callNextQuestion() - run")
            self.currentPage += 1
            questionVM.timelineGet(page: self.currentPage)
            

        }
    }
}

//MARK: - Content
extension TimelineView {
    var navBar : some View {
        HStack{
            NavigationLink {
                ProfileView(username: .constant(KeyChain.read(key: "username")!), isOwner: true)
            } label: {
                //profileVM.profileModel?.profileImage ?? ""
                KFImage(URL(string: profile_image))
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
            NavigationLink{
                UserSearchView()
            } label: {
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
            ScrollView(showsIndicators: false){
                if isProgress {
                    VStack{
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .frame(width: proxy.size.width)
                }
                else {
                    if isTimelineEmpty {
                        VStack(alignment: .center){
                            VStack(spacing: 0){
                                Text("팔로워가 아직 받은 질문이 없어요!")
                                    .font(.system(size: 16, weight: .none))
                                    .padding(.bottom, 13)
                                Button(action:{
                                    UIPasteboard.general.string = "chatty.kr/\(profileVM.profileModel?.username ?? "")"
                                    self.copyButtonPressed = true
                                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                                        self.copyButtonPressed = false
                                    }
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
                            ForEach(Array((questionVM.questionModel?.results ?? []).enumerated()), id:\.offset){ index, questiondata in
                                ResponsedCard(width:proxy.size.width-32, questiondata: questiondata, eventVM : eventVM)
                                    .onAppear{
                                        callNextTimeline(questiondata: questiondata)
                                    }
                                if index % 4 == 0 && index != 0 {
                                    AdBannerView(bannerID: "ca-app-pub-3017845272648516/7121150693", width: proxy.size.width)
                                }
                            }
                            if isProgress {
                                ProgressView()
                            }
                        }
                        .padding(.top, 10)
                        
                    }
                }
                
                if copyButtonPressed {
                    ProfileErrorView(msg: "복사 완료!")
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
            .background(Color("Background inner"))
            // 2023.06.06 Clyde 높이 제한 추가
            .frame(height: proxy.size.height)
            .frame(maxHeight: .infinity)
//            .allowsHitTesting(!questionVM.isLoading)
            .refreshable {
                self.initTimelineView()
            }
             
        }
        .onReceive(questionVM.isSuccessGetQuestion){ result in
            isProgress = false
            if result {
                isTimelineEmpty = true
            }else {
                isTimelineEmpty = false
            }
        }
        
        
    }
    
    var questionButton : some View {
        VStack(alignment: .trailing){
            if isClickedQuestion {
                VStack(alignment: .trailing){
                    NavigationLink {
                        QuestionDetailView(questionVM : questionVM)
                    } label: {
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
            }else{
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


//struct TimelineView_Previews: PreviewProvider {
//    static var previews: some View {
//        TimelineView().environmentObject(ChattyVM())
//    }
//}
