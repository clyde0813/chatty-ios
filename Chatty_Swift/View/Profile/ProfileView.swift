//
//  HomeView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/02/23.
//

import SwiftUI

enum PostTab {
    case completeQ, newQ, rejectedQ
}

struct ProfileView: View {
    @EnvironmentObject var userVM: UserVM
    
    var username: String
    var isOwner: Bool
    @State var response_rate: Int = 0
    @State var answered: Int = 0
    @State var unanswered: Int = 0
    @State var rejected: Int = 0
    @State var profile_image: String = ""
    @State var background_image: String = ""
    @State var profile_message: String? = ""
    @State var follower: Int = 0
    @State var following: Int = 0
    
    @State var questionEmpty : Bool = false
    
    @State var currentPostTab : PostTab = .completeQ
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom){
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
                        VStack {
                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("\(username)")
                                        .font(Font.system(size: 25, weight: .bold))
                                    Text("@\(username)")
                                        .font(Font.system(size:12, weight: .ultraLight))
                                    Text("\(profile_message ?? " ")")
                                        .font(Font.system(size: 16, weight: .light))
                                }
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
                                        .padding(.top, -90)
                                }
                            }
                            .padding(.top, 16)
                            .padding([.leading, .trailing], 16)
                            HStack {
                                VStack (alignment: .center) {
                                    Text("\(response_rate)%")
                                        .font(Font.system(size: 20, weight: .bold))
                                    Text("답변률")
                                        .font(Font.system(size: 14, weight: .ultraLight))
                                }
                                Spacer()
                                VStack (alignment: .center) {
                                    Text("\(follower)")
                                        .font(Font.system(size: 20, weight: .bold))
                                    Text("팔로워")
                                        .font(Font.system(size: 14, weight: .ultraLight))
                                }
                                Spacer()
                                VStack (alignment: .center) {
                                    Text("\(following)")
                                        .font(Font.system(size: 20, weight: .bold))
                                    Text("팔로잉")
                                        .font(Font.system(size: 14, weight: .ultraLight))
                                }
                            }
                            .padding([.leading, .trailing], 50)
                            .padding([.top, .bottom], 16)
                            
                        }
                        LazyVStack(alignment: .center, pinnedViews: [.sectionHeaders]) {
                            Section(header:
                                        HStack{
                                ZStack {
                                    if currentPostTab == .completeQ {
                                    }
                                    Button(action: {
                                        currentPostTab = .completeQ
                                    }){
                                        if currentPostTab == .completeQ {
                                            Text("답변 완료 \(answered)")
                                                .font(Font.system(size: 14, weight: .bold))
                                                .accentColor(.black)
                                        } else {
                                            Text("답변 완료 \(answered)")
                                                .font(Font.system(size: 14, weight: .none))
                                        }
                                    }
                                    .accentColor(.black)
                                }
                                .frame(width: proxy.size.width * 0.3, height: 40)
                                
                                ZStack {
                                    if currentPostTab == .newQ {
                                    }
                                    Button(action: {
                                        currentPostTab = .newQ
                                    }){
                                        if currentPostTab == .newQ {
                                            Text("새 질문 \(unanswered)")
                                                .font(Font.system(size: 14, weight: .bold))
                                                .accentColor(.white)
                                        } else {
                                            Text("새 질문 \(unanswered)")
                                                .font(Font.system(size: 14, weight: .none))
                                        }
                                    }
                                    .accentColor(.black)
                                }
                                .frame(width: proxy.size.width * 0.3, height: 40)
                                
                                ZStack {
                                    if currentPostTab == .rejectedQ {
                                        
                                    }
                                    Button(action: {
                                        currentPostTab = .rejectedQ
                                    }){
                                        if currentPostTab == .rejectedQ {
                                            Text("거절 질문 \(rejected)")
                                                .font(Font.system(size: 14, weight: .bold))
                                                .accentColor(.white)
                                        } else {
                                            Text("거절 질문 \(rejected)")
                                                .font(Font.system(size: 14, weight: .none))
                                        }
                                    }
                                    .accentColor(.black)
                                }
                                .frame(width: proxy.size.width * 0.3, height: 40)
                            }
                            ) {
                                ZStack{
                                    Color("Main Background")
                                    VStack{
                                        if self.questionEmpty {
                                            ForEach(userVM.questionData, id:\.pk) { questiondata in
                                                CardView(questionData: questiondata, username: self.username, profile_image: self.profile_image)
                                            }
                                        } else {
                                            Text("Loading")
                                        }
                                    }
                                }
                            }
                            .padding(.top, 8)
                        }
                    }
                    
                }
                if !isOwner {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("Main Color"))
                            .frame(width: 150,height: 40)
                        HStack{
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(Font.system(size: 14, weight: .none))
                            Text("익명 질문 보내기")
                                .font(Font.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                    }
                    .frame(width: 125)
                    .padding(.bottom, proxy.safeAreaInsets.bottom + 20)
                }
            }
            .ignoresSafeArea(.all)
            .onAppear(perform: {
                userVM.fetchUserInfo(username: username)
                userVM.answeredQuestion(username: username)
            })
            .onReceive(userVM.$userInfo) { userInfo in
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
                print(user)
            }
            .onReceive(userVM.$questionData) { data in
                if data.count == 0 {
                    self.questionEmpty = true
                }
            }
        }
    }
}



struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(username: "TestAccount1", isOwner: true).environmentObject(UserVM())
    }
}
