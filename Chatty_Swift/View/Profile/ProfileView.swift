//
//  HomeView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/02/23.
//

import SwiftUI

enum PostTab {
    case responsedTab, arrivedTab, refusedTab
}

struct ProfileView: View {
    @EnvironmentObject var chattyVM: ChattyVM
    
    var username: String
    var isOwner: Bool
    
    @State var widthFix : CGFloat = 0.0
    
    @State var response_rate: Int = 0
    @State var answered: Int = 0
    @State var unanswered: Int = 0
    @State var rejected: Int = 0
    @State var profile_image: String = ""
    @State var background_image: String = ""
    @State var profile_message: String? = ""
    @State var follower: Int = 0
    @State var following: Int = 0
    
    @State var currentPostTab : PostTab = .responsedTab
    
    @State var questionType : String = "responsed"
    
    @State var currentQuestionPage : Int = 1
    
    @State var questionList = [ResultDetail]()
    
    @State var questionEditorStatus : Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottomTrailing){
                ScrollView {
                    VStack {
                        ZStack (alignment: .topLeading) {
                            VStack{
                                AsyncImage(url: URL(string: "\(background_image)"))
                                {
                                    image in image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 220)
                                        .clipped()
                                } placeholder: {
                                }
                                Color.white
                                    .frame(height: 50)
                            }
                            .frame(height: 275)
                            .onAppear{
                                self.widthFix = (proxy.size.width - 40) / 3
                            }
                            if !isOwner{
                                //뒤로가기 버튼
                                Image(systemName: "chevron.backward")
                                    .foregroundColor(.white)
                                    .font(Font.system(size: 25, weight: .bold))
                                    .frame(alignment: .leading)
                                    .padding(.leading, 20)
                                    .padding(.top, proxy.safeAreaInsets.top)
                                    .padding()
                            }
                            ZStack {
                                AsyncImage(url: URL(string:
                                                        "\(profile_image)")) {
                                    image in image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 110)
                                        .clipShape(Circle())
                                        .overlay(Circle()
                                            .stroke(Color.white, lineWidth: 3))
                                } placeholder: {
                                }
                            }
                            .padding(.leading, 25)
                            .padding(.top, 155)
                        }
                        .frame(height: 245)
                        //프로필 정보 영역
                        VStack{
                            VStack(alignment: .leading, spacing: 8) {
                                HStack{
                                    Text("\(username)")
                                        .font(Font.system(size: 20, weight: .semibold))
                                    Spacer()
                                    if !isOwner{
                                        Text("팔로우")
                                            .fontWeight(.bold)
                                            .frame(width: 80, height: 40)
                                            .foregroundColor(Color("Pink"))
                                            .background(Color.white)
                                            .cornerRadius(16)
                                    } else {
                                        Image(systemName: "doc.on.doc")
                                            .fontWeight(.bold)
                                            .frame(width: 80, height: 40)
                                            .foregroundColor(Color.white)
                                            .background(Color("Pink"))
                                            .cornerRadius(16)
                                            .padding(.top, -60)
                                    }
                                }
                                .padding(.bottom, -2)
                                Text("@\(username)")
                                    .font(Font.system(size:12, weight: .ultraLight))
                                Text("\(profile_message ?? " ")")
                                    .font(Font.system(size: 16, weight: .light))
                                HStack{
                                    Text("\(follower)")
                                        .font(Font.system(size: 18, weight: .bold))
                                    Text("팔로워")
                                        .font(Font.system(size: 14, weight: .light))
                                        .padding(.trailing, 20)
                                    Text("\(following)")
                                        .font(Font.system(size: 18, weight: .bold))
                                    Text("팔로잉")
                                        .font(Font.system(size: 14, weight: .light))
                                }
                            }
                            .padding(.top, 8)
                            .padding([.leading, .trailing], 16)
                            //프로필 정보 영역 end
                            
                            // middle 받은 질문수 ~ 오늘 방문자 수 영역
                            HStack(spacing: 0) {
                                Spacer()
                                VStack (alignment: .center) {
                                    Text("\(answered + unanswered + rejected)")
                                        .font(Font.system(size: 20, weight: .semibold))
                                    Text("받은 질문 수")
                                        .font(Font.system(size: 14, weight: .ultraLight))
                                }
                                .frame(width: self.widthFix)
                                Spacer()
                                VStack (alignment: .center) {
                                    Text("\(response_rate)%")
                                        .font(Font.system(size: 20, weight: .semibold))
                                    Text("답변률")
                                        .font(Font.system(size: 14, weight: .ultraLight))
                                }
                                .frame(width: self.widthFix)
                                Spacer()
                                VStack (alignment: .center) {
                                    Text("345")
                                        .font(Font.system(size: 20, weight: .semibold))
                                    Text("오늘 방문자 수")
                                        .font(Font.system(size: 14, weight: .ultraLight))
                                }
                                .frame(width: self.widthFix)
                                Spacer()
                            }
                            .frame(width: proxy.size.width)
                            .padding(.top, 16)
                            // middle end
                        }
                        // 질문 카드 및 탭 헤더 영역
                        LazyVStack(alignment: .center, pinnedViews: [.sectionHeaders]) {
                            Section(header:
                                        //질문 탭 헤더 시작
                                    HStack(alignment: .center){
                                ZStack{
                                    if currentPostTab == .responsedTab {
                                    }
                                    Button(action: {
                                        currentPostTab = .responsedTab
                                        self.questionType = "responsed"
                                        chattyVM.questionModel = nil
                                        self.questionList = []
                                        self.currentQuestionPage = 1
                                        chattyVM.questionGet(questionType: questionType, username: username, page: self.currentQuestionPage)
                                    }){
                                        if currentPostTab == .responsedTab {
                                            VStack(alignment: .center, spacing: 0){
                                                Text("답변 완료")
                                                    .font(Font.system(size: 14, weight: .bold))
                                                    .accentColor(.black)
                                                Spacer()
                                                Rectangle()
                                                    .fill(Color("Pink"))
                                                    .frame(width: 50, height: 2)
                                            }
                                        } else {
                                            Text("답변 완료")
                                                .font(Font.system(size: 14, weight: .none))
                                        }
                                    }
                                    .accentColor(.black)
                                }
                                .frame(width: self.widthFix)
                                
                                ZStack {
                                    if currentPostTab == .arrivedTab {
                                    }
                                    Button(action: {
                                        currentPostTab = .arrivedTab
                                        self.questionType = "arrived"
                                        chattyVM.questionModel = nil
                                        self.questionList = []
                                        self.currentQuestionPage = 1
                                        chattyVM.questionGet(questionType: questionType, username: username, page: self.currentQuestionPage)
                                    }){
                                        if currentPostTab == .arrivedTab {
                                            VStack(alignment: .center, spacing: 0){
                                                Text("새 질문")
                                                    .font(Font.system(size: 14, weight: .bold))
                                                    .accentColor(.black)
                                                Spacer()
                                                Rectangle()
                                                    .fill(Color("Pink"))
                                                    .frame(width: 50, height: 2)
                                            }
                                        } else {
                                            Text("새 질문")
                                                .font(Font.system(size: 14, weight: .none))
                                        }
                                    }
                                    .accentColor(.black)
                                }
                                .frame(width: self.widthFix)
                                
                                ZStack {
                                    if currentPostTab == .refusedTab {
                                    }
                                    Button(action: {
                                        currentPostTab = .refusedTab
                                        self.questionType = "refused"
                                        chattyVM.questionModel = nil
                                        self.questionList = []
                                        self.currentQuestionPage = 1
                                        chattyVM.questionGet(questionType: questionType, username: username, page: self.currentQuestionPage)
                                    }){
                                        if currentPostTab == .refusedTab {
                                            VStack(alignment: .center, spacing: 0){
                                                Text("거절 질문")
                                                    .font(Font.system(size: 14, weight: .bold))
                                                    .accentColor(.black)
                                                Spacer()
                                                Rectangle()
                                                    .fill(Color("Pink"))
                                                    .frame(width: 50, height: 2)
                                            }
                                        } else {
                                            Text("거절 질문")
                                                .font(Font.system(size: 14, weight: .none))
                                        }
                                    }
                                    .accentColor(.black)
                                }
                                .frame(width: self.widthFix)
                            }
                                .frame(width: proxy.size.width, height: 20)
                                .background(Rectangle()
                                    .foregroundColor(.white))
                                    .padding(.top, 20)
                                    //질문 탭 헤더 종료
                            ) {
                                ZStack{
                                    Color("Main Background")
                                    LazyVStack(spacing: 0){
                                        if self.questionList.count != 0 {
                                                ForEach(questionList, id:\.pk) { questiondata in
                                                    if self.currentPostTab == .responsedTab {
                                                        ResponsedCard(width: proxy.size.width - 32, questionData: questiondata, username: self.username, profile_image: self.profile_image)
                                                            .padding(.top, 16)
                                                            .onAppear{
                                                                if !questionList.isEmpty && questiondata.pk == questionList.last!.pk && chattyVM.questionModel?.next != nil{                self.currentQuestionPage += 1
                                                                    chattyVM.questionGet(questionType: questionType,username: username, page: self.currentQuestionPage)
                                                                }
                                                            }
                                                    }
                                                    if self.currentPostTab == .arrivedTab {
                                                        ArrivedCard(width: proxy.size.width - 32,questionData: questiondata)
                                                            .padding(.top, 16)
                                                            .onAppear{
                                                                if !questionList.isEmpty && questiondata.pk == questionList.last!.pk && chattyVM.questionModel?.next != nil{                self.currentQuestionPage += 1
                                                                    chattyVM.questionGet(questionType: questionType,username: username, page: self.currentQuestionPage)
                                                                }
                                                            }
                                                    }
                                                    if self.currentPostTab == .refusedTab {
                                                        RefusedCard(width: proxy.size.width - 32, questionData: questiondata)
                                                            .padding(.top, 16)
                                                            .onAppear{
                                                                if !questionList.isEmpty && questiondata.pk == questionList.last!.pk && chattyVM.questionModel?.next != nil {
                                                                    self.currentQuestionPage += 1
                                                                    chattyVM.questionGet(questionType: questionType,username: username, page: self.currentQuestionPage)
                                                                }
                                                            }
                                                    }
                                                }
                                        } else {
                                            VStack(alignment: .center){
                                                ProgressView()
                                                    .font(.system(size:20))
                                            }
                                            .frame(width: proxy.size.width, height: 300)
                                        }
                                    }
                                    .padding(.bottom, questionList.count > 2 ? 100 : 200)
                                }
                            }
                        }
                    }
                }
                
                if isOwner {
                    Button(action: {
                        self.questionEditorStatus = true
                    }
                    ){
                        NewQuestionButton()
                            .padding(.bottom, 100)
                            .padding(.trailing, 16)
                    }
                }
            }
            .onAppear(perform: {
                self.questionList = []
                self.currentQuestionPage = 1
                chattyVM.fetchUserInfo(username: username)
                chattyVM.questionGet(questionType: questionType, username: username, page: self.currentQuestionPage)
            })
            .onReceive(chattyVM.$profileModel) { userInfo in
                guard let user = userInfo else { return }
                self.profile_message = user.profileMessage
                self.profile_image = user.profileImage
                self.background_image = user.backgroundImage
                self.response_rate = user.responseRate
                self.follower = user.follower
                self.following = user.following
                self.answered = user.questionCount.answered
                self.unanswered = user.questionCount.unanswered
                self.rejected = user.questionCount.rejected
            }
            .onReceive(chattyVM.$questionModel) { data in
                self.questionList += data?.results ?? []
            }
            .onReceive(chattyVM.refuseComplete) {
                self.questionList = []
                self.currentQuestionPage = 1
                chattyVM.questionGet(questionType: questionType, username: username, page: self.currentQuestionPage)
            }
            .sheet(isPresented: $questionEditorStatus){
                QuestionEditor(username: username)
                    .presentationDetents([.fraction(0.45)])
                    .onDisappear{
                        self.questionList = []
                        self.currentQuestionPage = 1
                        chattyVM.questionGet(questionType: questionType, username: username, page: self.currentQuestionPage)
                    }
            }
            .ignoresSafeArea(.all)
            .refreshable {
                self.questionList = []
                self.currentQuestionPage = 1
                chattyVM.fetchUserInfo(username: username)
                chattyVM.questionGet(questionType: questionType, username: username, page: self.currentQuestionPage)
            }
        }
    }
}



struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(username: "TestAccount1", isOwner: true).environmentObject(ChattyVM())
    }
}
