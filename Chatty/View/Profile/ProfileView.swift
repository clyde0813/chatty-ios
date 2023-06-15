//
//  HomeView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/02/23.
//

import SwiftUI
import Kingfisher

enum PostTab {
    case responsedTab, arrivedTab, refusedTab
}

struct ProfileView: View {
    @EnvironmentObject var chattyVM: ChattyVM
    @StateObject var profileVM = ProfileVM()
    @StateObject var questionVM = QuestionVM()
    
    @StateObject var eventVM = ChattyEventVM()
    
    @Environment(\.dismiss) private var dismiss

    @Binding var username: String
    
    @State var selectFollow : followTab = .follower
    
    @State var isOwner: Bool
        
    @State var offset: CGFloat = 0
    
    @State var tabBarOffset: CGFloat = 0
    
    @State var titleOffset: CGFloat = 0
    
    
    @State var currentPostTab : PostTab = .responsedTab
    
    @State var questionType : String = "responsed"
    
    @State var currentQuestionPage : Int = 1
    
    @State var isQuestionEmpty = false
    
    @State var questionEditorStatus : Bool = false
    
    @State var questionEmpty : Bool = false
    
    @State var questionPostSuccess : Bool = false
    
    @State var copyButtonPressed : Bool = false
    
    @State var reportSuccess : Bool = false
    
    @State var deleteSuccess : Bool = false
    
    @State var isSheet : Bool = false
    
    @State var isAnswerSheet : Bool = false
    
    @GestureState private var dragOffset = CGSize.zero
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let widthFix = (proxy.size.width - 40) / 3
            ZStack(alignment: .bottomTrailing){
                ScrollView(.vertical, showsIndicators: false, content: {
                    // ScrollView content VStack
                    VStack(spacing: 0){
                        
                        
                        GeometryReader { proxy -> AnyView in

                            // Sticky Header...
                            let minY = proxy.frame(in: .global).minY

                            DispatchQueue.main.async {

                                self.offset = minY
                            }

                            return AnyView(
                                ZStack{
                                    KFImage(URL(string: profileVM.profileModel?.backgroundImage ?? ""))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(
                                            width: size.width,
                                            height: minY > 0 ? 180 + minY : 180, alignment: .center
                                            )
                                    HStack(spacing: 0) {
                                        Button(action:{
                                            dismiss()
                                            print("dismiss()")
                                        }){
                                            Image(systemName: "arrow.left")
                                                .font(.system(size:16, weight: .bold))
                                                .foregroundColor(Color.white)
                                                .background(
                                                    Circle()
                                                        .fill(Color("Card Share Background"))
                                                        .frame(width: 32, height: 32)
                                                )
                                        }
                                        .padding(.leading, 25)
                                        .padding(.bottom, 40)
                                        Spacer()
                                        //2023.06.15 -신현호
                                        //아직기능이없어서, 주석처리
//                                        Button(action:{
//                                            dismiss()
//                                        }){
//                                            Image(systemName: "ellipsis")
//                                                .font(.system(size:16, weight: .bold))
//                                                .foregroundColor(Color.white)
//                                                .rotationEffect(.degrees(-90))
//                                                .background(
//                                                    Circle()
//                                                        .fill(Color("Card Share Background"))
//                                                        .frame(width: 32, height: 32)
//                                                )
//                                        }
//                                        .padding(.trailing, 25)
//                                        .padding(.bottom, 40)
                                    }
                                    BlurView()
                                        .opacity(blurViewOpacity())
                                    HStack{
                                        Button(action:{
                                            dismiss()
                                        }){
                                            Image(systemName: "arrow.left")
                                                .font(.system(size:16, weight: .bold))
                                                .foregroundColor(Color.white)
                                                .background(
                                                    Circle()
                                                        .fill(Color("Card Share Background"))
                                                        .frame(width: 32, height: 32)
                                                )
                                        }
                                        .padding(.leading, 25)
                                        .padding(.bottom, 10)
                                        Spacer()
                                        VStack(alignment: .center, spacing: 8){
                                            Text("\(profileVM.profileModel?.profile_name ?? "")")
                                                .font(Font.system(size: 18, weight: .bold))
                                                .foregroundColor(Color.white)

                                            Text("답변완료 \(profileVM.profileModel?.questionCount.answered ?? 0)개")
                                                .font(Font.system(size: 14, weight: .bold))
                                                .foregroundColor(Color.white)
                                        }
                                        Spacer()
                                        //2023.06.15 -신현호
                                        //아직기능이없어서, 주석처리
//                                        Button(action:{
//                                            dismiss()
//                                        }){
//                                            Image(systemName: "ellipsis")
//                                                .font(.system(size:16, weight: .bold))
//                                                .foregroundColor(Color.white)
//                                                .rotationEffect(.degrees(-90))
//                                                .background(
//                                                    Circle()
//                                                        .fill(Color("Card Share Background"))
//                                                        .frame(width: 32, height: 32)
//                                                )
//                                        }
//                                        .padding(.trailing, 25)
//                                        .padding(.bottom, 10)
                                    }
                                    // to slide from bottom added extra 60..
                                    .offset(y: 120)
                                    .offset(y: titleOffset > 100 ? 0 : -getTitleTextOffset())
                                    .opacity(titleOffset < 100 ? 1 : 0)
                                }
                                    .clipped()
                                //offset이 -80 이하일 경우 background image 상단 dismiss 버튼 허용
                                    .allowsHitTesting(-offset > 80 ? false : true)
                                // Stretchy Header...
                                    .frame(height: minY > 0 ? 180 + minY : nil)
                                    .offset(y: minY > 0 ? -minY : -minY < 80 ? 0 : -minY - 80)

                            )}
                        .frame(height: 180)
                        .zIndex(1)
                        
                        
                        // Profile
                        VStack(spacing: 0) {
                            
                            //프로필 정보 영역
                            VStack(alignment: .leading, spacing: 8) {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(spacing: 0){
                                        KFImage(URL(string: profileVM.profileModel?.profileImage ?? ""))
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 110, height: 110)
                                                .clipShape(Circle())
                                                .overlay(Circle()
                                                    .stroke(Color.white, lineWidth: 3))
                                                .scaleEffect(getScale())
                                                .padding(.top, -50)
                                        Spacer()
                                        ZStack{
                                            //2022.06.13 -신현호
                                            if profileVM.profileModel?.username != KeyChain.read(key: "username"){
                                                Button {
                                                    profileVM.Follow(username: profileVM.profileModel?.username ?? "")
                                                    //2022.06.13 -신현호
                                                    profileVM.profileModel?.followState.toggle()
                                                    //2022.06.15 -신현호
                                                    if profileVM.profileModel?.followState == true {
                                                        profileVM.profileModel?.follower += 1
                                                    }else{
                                                        profileVM.profileModel?.follower -= 1
                                                    }
                                                } label: {
                                                    if let followState = profileVM.profileModel?.followState {
                                                        if !followState {
                                                            Text("팔로우")
                                                                .font(.system(size:14, weight: .bold))
                                                                .frame(height: 40)
                                                                .frame(width: 90)
                                                                .foregroundColor(.white)
                                                                .background(
                                                                    Capsule()
                                                                        .fill(Color("Pink Main"))
                                                                )
                                                        }else{
                                                            //2022.06.15 -신현호
                                                            Text("팔로우취소")
                                                                .font(.system(size:14, weight: .bold))
                                                                .frame(height: 40)
                                                                .frame(width: 90)
                                                                .foregroundColor(.white)
                                                                .background(
                                                                    Capsule()
                                                                        .fill(Color("Grey400"))
//                                                                        .strokeBorder(Color("Pink Main"), lineWidth: 1)
                                                                )
                                                        }
                                                    }
                                                }
                                            } else {
                                                NavigationLink {
                                                    ProfileEditView(profileVM: profileVM)
                                                } label: {
                                                    Text("프로필 수정")
                                                        .font(.system(size:14, weight: .bold))
                                                        .frame(height: 40)
                                                        .frame(width: 90)
                                                        .foregroundColor(Color("Pink Main"))
                                                        .background(
                                                            Capsule()
                                                                .strokeBorder(Color("Pink Main"), lineWidth: 1)
                                                        )
                                                }
                                            }
                                        }
                                    }
                                    Text(profileVM.profileModel?.profile_name ?? "")
                                        .font(Font.system(size: 20, weight: .semibold))
                                        .padding(.bottom, -4)
                                    Text("@\(profileVM.profileModel?.username ?? "")")
                                        .font(Font.system(size:12, weight: .ultraLight))
                                    if profileVM.profileModel?.profileMessage != nil {
                                        Text(profileVM.profileModel?.profileMessage ?? "")
                                            .font(Font.system(size: 16, weight: .light))
                                        //2022.06.13 -신현호
                                            .lineLimit(3)
                                    }
                                    
                                    //MARK: - follow/following
                                    HStack{
                                        //2022.06.11 신현호
                                        NavigationLink {
                                            FollowView(username: $username,currentTab: followTab.follower)
                                        } label: {
                                            Text("\(profileVM.profileModel?.follower ?? 0)")
                                                .font(Font.system(size: 18, weight: .bold))
                                                .foregroundColor(.black)
                                            Text("팔로워")
                                                .font(Font.system(size: 14, weight: .light))
                                                .padding(.trailing, 20)
                                                .foregroundColor(.black)
                                        }
//                                        .simultaneousGesture(TapGesture().onEnded {selectFollow = .follower})
                                        NavigationLink {
                                            FollowView(username: $username,currentTab: followTab.following)
                                        } label: {
                                            Text("\(profileVM.profileModel?.following ?? 0)")
                                                .font(Font.system(size: 18, weight: .bold))
                                                .foregroundColor(.black)
                                            Text("팔로잉")
                                                .font(Font.system(size: 14, weight: .light))
                                                .foregroundColor(.black)
                                        }
//                                        .simultaneousGesture(TapGesture().onEnded {selectFollow = .following})
                                    }
                                }
                                .padding([.leading, .trailing], 16)
                                HStack(spacing: 0) {
                                    Spacer()
                                    VStack (alignment: .center) {
                                        Text("\(profileVM.SumOfQuestion())")
                                            .font(Font.system(size: 20, weight: .semibold))
                                        Text("받은 질문 수")
                                            .font(Font.system(size: 14, weight: .ultraLight))
                                    }
                                    .frame(width: widthFix)
                                    Spacer()
                                    VStack (alignment: .center) {
                                        Text("\(profileVM.profileModel?.responseRate ?? 0)%")
                                            .font(Font.system(size: 20, weight: .semibold))
                                        Text("답변률")
                                            .font(Font.system(size: 14, weight: .ultraLight))
                                    }
                                    .frame(width: widthFix)
                                    Spacer()
                                    VStack (alignment: .center) {
                                        Text("\(profileVM.profileModel?.views ?? 0)")
                                            .font(Font.system(size: 20, weight: .semibold))
                                        Text("오늘 방문자 수")
                                            .font(Font.system(size: 14, weight: .ultraLight))
                                    }
                                    .frame(width: widthFix)
                                    Spacer()
                                }
                                .frame(width: proxy.size.width)
                                .padding(.top, 10)
                            }
                            .overlay(

                                GeometryReader{proxy -> Color in

                                    let minY = proxy.frame(in: .global).minY

                                    DispatchQueue.main.async {
                                        self.titleOffset = minY
                                    }
                                    return Color.clear
                                }
                                    .frame(width: 0, height: 0)

                                ,alignment: .top
                            )
                            //프로필 정보 영역 end
                            
                            
                            
                            VStack(spacing: 0){
                                HStack(alignment: .bottom, spacing: 0){
                                    ZStack(alignment: .bottom){
                                        Button(action: {
                                            self.questionType = "responsed"
                                            currentPostTab = .responsedTab
                                            self.initProfileView()
                                        }){
                                            if currentPostTab == .responsedTab {
                                                VStack(alignment: .center, spacing: 0){
                                                    Text("답변 완료")
                                                        .font(Font.system(size: 14, weight: .bold))
                                                        .accentColor(.black)
                                                        .padding(.bottom, 9)
                                                    Rectangle()
                                                        .fill(Color("Main Secondary"))
                                                        .frame(width: 50, height: 3)
                                                }
                                            } else {
                                                Text("답변 완료")
                                                    .font(Font.system(size: 14, weight: .semibold))
                                                    .foregroundColor(Color.gray)
                                                    .padding(.bottom, 12)
                                            }
                                        }
                                        .accentColor(.black)
                                    }
                                    .frame(width: widthFix, alignment: .bottom)
                                    
                                    ZStack {
                                        if profileVM.profileModel?.username == KeyChain.read(key: "username") {
                                            Button(action: {
                                                currentPostTab = .arrivedTab
                                                self.questionType = "arrived"
                                                self.initProfileView()
                                            }){
                                                if currentPostTab == .arrivedTab {
                                                    VStack(alignment: .center, spacing: 0){
                                                        Text("새 질문")
                                                            .font(Font.system(size: 14, weight: .bold))
                                                            .accentColor(.black)
                                                        Spacer()
                                                        Rectangle()
                                                            .fill(Color("Main Secondary"))
                                                            .frame(width: 50, height: 3)
                                                    }
                                                } else {
                                                    Text("새 질문")
                                                        .font(Font.system(size: 14, weight: .semibold))
                                                        .foregroundColor(Color.gray)
                                                        .padding(.bottom, 12)
                                                }
                                            }
                                            .accentColor(.black)
                                        } else {
                                            Text("새 질문")
                                                .font(Font.system(size: 14, weight: .semibold))
                                                .foregroundColor(Color.gray)
                                                .padding(.bottom, 12)
                                        }
                                    }
                                    .frame(width: widthFix)
                                    
                                    ZStack {
                                        if profileVM.profileModel?.username == KeyChain.read(key: "username") {
                                            Button(action: {
                                                currentPostTab = .refusedTab
                                                self.questionType = "refused"
                                                self.initProfileView()
                                            }){
                                                if currentPostTab == .refusedTab {
                                                    VStack(alignment: .center, spacing: 0){
                                                        Text("거절 질문")
                                                            .font(Font.system(size: 14, weight: .bold))
                                                            .accentColor(.black)
                                                        Spacer()
                                                        Rectangle()
                                                            .fill(Color("Main Secondary"))
                                                            .frame(width: 50, height: 3)
                                                    }
                                                } else {
                                                    Text("거절 질문")
                                                        .font(Font.system(size: 14, weight: .semibold))
                                                        .foregroundColor(Color.gray)
                                                        .padding(.bottom, 12)
                                                }
                                            }
                                            .accentColor(.black)
                                        } else {
                                            Text("거절 질문")
                                                .font(Font.system(size: 14, weight: .semibold))
                                                .foregroundColor(Color.gray)
                                                .padding(.bottom, 12)
                                        }
                                    }
                                    .frame(width: widthFix)
                                }
                            }
                            .padding(.top, 30)
                            .frame(width: proxy.size.width)
                            .background(Color.white)
                            .offset(y: tabBarOffset < 90 ? -tabBarOffset + 90 : 0)
                            .overlay(
                                GeometryReader{reader -> Color in

                                    let minY = reader.frame(in: .global).minY

                                    DispatchQueue.main.async {
                                        self.tabBarOffset = minY
                                    }

                                    return Color.clear
                                }
                                    .frame(width: 0, height: 0)

                                ,alignment: .top
                            )
                            .zIndex(1)
                            
                            
                            ZStack(alignment: .top){
                                Color("Background inner")
                                    .frame(minHeight: 500,
                                           maxHeight: .infinity
                                           )
                                //MARK: - lazyVstack
                                LazyVStack(spacing: 16){
                                    if isQuestionEmpty == false{
                                        if let questionlist = questionVM.questionModel?.results {
                                            ForEach(questionlist, id:\.pk){ questiondata in
                                                if self.currentPostTab == .responsedTab {
                                                    ResponsedCard(width: proxy.size.width - 32, questiondata: questiondata, eventVM : eventVM)
                                                    .onAppear{
                                                        callNextQuestion(questiondata: questiondata)
                                                    }
                                                }
                                                else if self.currentPostTab == .arrivedTab {
                                                    ArrivedCard(width: proxy.size.width - 32, questiondata: questiondata, eventVM: eventVM)
                                                        .onAppear{
                                                            callNextQuestion(questiondata: questiondata)
                                                        }
                                                }
                                                else if self.currentPostTab == .refusedTab {
                                                    RefusedCard(width: proxy.size.width - 32, questiondata: questiondata)
                                                    .onAppear{
                                                        callNextQuestion(questiondata: questiondata)
                                                    }
                                                }
                                            }
                                            
                                        }
                                    }
                                    else if isQuestionEmpty == true {
                                        
                                        VStack(alignment: .center){
                                            VStack(spacing: 0){
                                                Text("아직 받은 질문이 없어요!")
                                                    .font(.system(size: 16, weight: .none))
                                                    .padding(.bottom, 13)
                                                Button(action:{
                                                    UIPasteboard.general.string = "chatty.kr/\(profileVM.profileModel?.username ?? "")"
                                                    self.copyButtonPressed = true
                                                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                                                        self.copyButtonPressed = false
                                                    }
                                                }){
                                                    Text("프로필 링크 복사하기")
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
                                    else {
                                        VStack(alignment: .center){
                                            Spacer()
                                            ProgressView()
                                            Spacer()
                                        }
                                        .frame(width: proxy.size.width, height: 300)
                                    }
                                }
                                .padding([.top, .bottom])

                            }
                            .zIndex(0)
                        }
                        .zIndex(-offset > 80 ? 0 : 1)
                    }
                })
                if !(profileVM.profileModel?.username == KeyChain.read(key: "username")) {
                    Button(action: {
                        self.questionEditorStatus = true
                    }
                    ){
                        NewQuestionButton()
                            .padding([.bottom, .trailing], 16)
                    }
                }
                
                if questionPostSuccess {
                    ProfileErrorView(msg:"질문 보내기 성공!")
                }
                
                if copyButtonPressed {
                    ProfileErrorView(msg: "복사 완료!")
                }
                
                if reportSuccess {
                    ProfileErrorView(msg: "신고가 접수되었습니다!")
                }
                
                if deleteSuccess {
                    ProfileErrorView(msg: "삭제가 완료되었습니다!")
                }
            }
            .ignoresSafeArea(.all, edges: .top)
            .onAppear(perform: {
                self.initProfileView()
                
            })
            .onReceive(questionVM.isSuccessGetQuestion){ result in
                if result {
                    self.isQuestionEmpty = false
                } else {
                    self.isQuestionEmpty = true
                }
            }
            .onReceive(questionVM.refuseComplete) {
                print(".onReceive(questionVM.refuseComplete)")
                self.initProfileView()
            }
            .onReceive(questionVM.reportSuccess) {
                self.initProfileView()
                self.reportSuccess = true
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                    self.reportSuccess = false
                }
            }
            .onReceive(questionVM.deleteSuccess) {
                self.initProfileView()
                self.deleteSuccess = true
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                    self.deleteSuccess = false
                }
            }
            .onReceive(eventVM.sheetPublisher){
                isSheet = true
            }
            .onReceive(questionVM.questionPostSuccess){
                self.questionPostSuccess = true
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                    self.questionPostSuccess = false
                }
            }
            .sheet(isPresented: $isSheet, onDismiss: {
                isSheet = false
            }) {
                QuestionOption(eventVM: eventVM)
                    .presentationDetents([.fraction(0.4)])
            }
            .sheet(isPresented: $questionEditorStatus,onDismiss:{
                questionEditorStatus = false
            }){
                QuestionEditor(username: $username, questionVM: questionVM)
                    .presentationDetents([.fraction(0.4)])
            }
            .onReceive(eventVM.deletePublisher){
                questionVM.questionDelete(question_id: eventVM.data?.pk ?? 0)
            }
            .onReceive(eventVM.reportPublisher){
                questionVM.questionReport(question_id: eventVM.data?.pk ?? 0)
            }
            .onReceive(eventVM.refusePublisher){
                questionVM.questionRefuse(question_id: eventVM.data?.pk ?? 0)
            }
            .onReceive(eventVM.answerSheetPublisher){
                isAnswerSheet = true
            }
            .sheet(isPresented: $isAnswerSheet, onDismiss: {
                isAnswerSheet = false
            }) {
                AnswerEditor(eventVM: eventVM)
                    .presentationDetents([.fraction(0.45)])
                    .onDisappear{
                        self.initProfileView()
                    }
            }
            .onReceive(eventVM.answerPublisher){
                questionVM.answerPost(question_id: eventVM.data?.pk ?? 0, content: eventVM.data?.answerContent ?? "")
            }
            .refreshable {
                self.initProfileView()
            }
            .onChange(of: self.offset) {_ in
                print(self.offset)
            }
        }
        .navigationBarHidden(true)
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
                    if(value.startLocation.x < 20 && value.translation.width > 100) {
                        dismiss()
                    }
                }))
        
    }
    
    func getOffset()->CGFloat{
        
        let progress = (-offset / 80) * 20
        
        return progress <= 20 ? progress : 20
    }
    
    func getTitleTextOffset()->CGFloat{
        
        // some amount of progress for slide effect..
        let progress = 20 / titleOffset
        
        let offset = 60 * (progress > 0 && progress <= 1 ? progress : 1)
        
        return offset
    }
    
    func getScale()->CGFloat{
        
        let progress = -offset / 80
        
        let scale = 1.8 - (progress < 1.0 ? progress : 1)
        
        // since were scaling the view to 0.8...
        // 1.8 - 1 = 0.8....
        
        return scale < 1 ? scale : 1
    }
    
    func blurViewOpacity()->Double{
        
        let progress = -(offset + 80) / 150
        
        return Double(-offset > 80 ? progress : 0)
    }
    
    func callNextQuestion(questiondata: ResultDetail){
        print("callNextQuestion() - run")
        print(questiondata)
        if questionVM.questionModel?.results.isEmpty == false && questionVM.questionModel?.next != nil && questiondata.pk == questionVM.questionModel?.results.last?.pk{
            self.currentQuestionPage += 1
            questionVM.questionGet(questionType: questionType,username: username, page: self.currentQuestionPage)
        }
        
    }
    
    func initProfileView() {
        print("run itit")
        self.questionEmpty = false
        questionVM.questionModel?.results.removeAll()
        self.currentQuestionPage = 1
        profileVM.profileGet(username: username)
        questionVM.questionGet(questionType: questionType, username: username, page: self.currentQuestionPage)
    }
}

struct ProfileErrorView : View {
    @State var msg : String
    var body: some View{
        VStack{
            Spacer()
            HStack{
                Spacer()
                Text(msg)
                    .frame(width: 310, height: 40)
                    .foregroundColor(Color.white)
                    .background(Color("Error Background"))
                    .cornerRadius(16)
                    .padding(.bottom, 50)
                Spacer()
            }
        }
    }
}


//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView(username: .constant("TestAccount1"), isOwner: true).environmentObject(ChattyVM())
//    }
//}
