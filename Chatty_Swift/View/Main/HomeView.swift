//
//  HomeView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/02/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userVM: UserVM
    
    @State var username: String = ""
    @State var response_rate: Int = 0
    @State var answered: Int = 0
    @State var unanswered: Int = 0
    @State var rejected: Int = 0
    @State var profile_image: String = ""
    @State var background_image: String = ""
    @State var profile_message: String? = ""
    @State var follower: Int = 0
    @State var following: Int = 0


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
                            Image(systemName: "chevron.backward")
                                .foregroundColor(.white)
                                .font(Font.system(size: 25, weight: .bold))
                                .frame(alignment: .leading)
                                .padding(.leading, 20)
                                .padding(.top, proxy.safeAreaInsets.top)
                                .padding()
                            ZStack {
                                AsyncImage(url: URL(string:
                                                        "\(profile_image)")) {
                                    image in image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 110)
                                        .clipShape(Circle())
                                } placeholder: {
                                }
                            }
                            .padding(.leading, 30)
                            .padding(.top, 155)
                        }
                        .frame(height: 245)
                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(username)")
                                        .font(Font.system(size: 25, weight: .bold))
                                    Text("\(profile_message ?? " ")")
                                        .font(Font.system(size: 12, weight: .ultraLight))
                                }
                                Spacer()
                                Text("팔로우")
                                    .fontWeight(.bold)
                                    .frame(width: 80, height: 40)
                                    .foregroundColor(Color("Main Color"))
                                    .background(Color("Sub Color"))
                                    .cornerRadius(16)
                            }
                            .padding([.leading, .trailing], 30)
                            HStack {
                                Spacer()
                                VStack (alignment: .center) {
                                    Text("\(response_rate)%")
                                        .font(Font.system(size: 16, weight: .bold))
                                    Text("답변률")
                                        .font(Font.system(size: 12, weight: .ultraLight))
                                }
                                Spacer()
                                VStack (alignment: .center) {
                                    Text("\(follower)")
                                        .font(Font.system(size: 16, weight: .bold))
                                    Text("팔로워")
                                        .font(Font.system(size: 12, weight: .ultraLight))
                                }
                                Spacer()
                                VStack (alignment: .center) {
                                    Text("\(following)")
                                        .font(Font.system(size: 16, weight: .bold))
                                    Text("팔로잉")
                                        .font(Font.system(size: 12, weight: .ultraLight))
                                }
                                Spacer()
                            }
                            .padding()
                            ZStack{
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color("Sub Color"))
                                    .frame(height: 40)
                                HStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color("Main Color"))
                                            .frame(height: 40)
                                        Text("답변완료 \(answered)")
                                            .font(Font.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                        
                                    }
                                    .frame(width: 125)
                                    Spacer()
                                    Text("새 질문 \(unanswered)")
                                        .font(Font.system(size: 14, weight: .none))
                                    Spacer()
                                    Text("거절 질문 \(rejected)")
                                        .font(Font.system(size: 14, weight: .none))
                                    Spacer()
                                }
                            }
                            .padding([.leading, .trailing], 30)
                        }
                        .frame(height: 200)
                        ZStack {
                            Color("Main Background")
                            Spacer()
                            VStack(alignment: .center) {
                                ForEach(0..<10) { i in
                                    CardView()
                                }
                            }
                            .padding(.top, 8)
                            .padding(.bottom, 60)
                        }
                    }
                }
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
            .ignoresSafeArea(.all)
            .onAppear(perform: {
                userVM.fetchUserInfo()
            })
            .onReceive(userVM.$userInfo) { userInfo in
                guard let user = userInfo else { return }
                self.username = user.username
                self.profile_message = user.profileMessage
                self.profile_image = user.profileImage
                self.background_image = user.backgroundImage
                self.follower = user.follower
                self.following = user.following
                self.answered = user.questionCount.answered
                self.unanswered = user.questionCount.unanswered
                self.rejected = user.questionCount.rejected
                
                print(user)
            }
        }
        .tag(BottomTab.home)
        .tabItem{
            Image(systemName: "house")
            Text("롬")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(UserVM())
    }
}
