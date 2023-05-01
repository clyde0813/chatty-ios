//
//  CommunityView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/02/23.
//

import SwiftUI

struct CommunityView: View {
    @EnvironmentObject var chattyVM: ChattyVM
    
    @State var currentUser : Int = 0
    @State var percent : Double = 0.0

    var body: some View {
        GeometryReader{ proxy in
            ZStack{
                Color("Background inner")
                VStack(alignment: .leading, spacing: 0){
                    HStack{
                        Image("Logo Small")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 32, height: 32)
                    }
                    .frame(width: proxy.size.width, height: 60)
                    .background(Rectangle()
                        .fill(Color.white)
                        .shadow(color: Color("Shadow Button"), radius: 3, x: 0, y: 6)
                    )
                    VStack(alignment: .leading, spacing : 10){
                        Text("채티는 지금?")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color("Pink Main"))
                            .padding(.bottom, 15)
                        HStack(spacing : 0){
                            Text("\(self.currentUser.formatted())명")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(Color("Main Primary"))
                            Text("이")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(Color("Pink Main"))
                        }
                        Text("사용하고 있어요.")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color("Main Primary"))
                    }
                    .padding(.top, 88)
                    .padding(.leading, 32)
                    VStack(alignment: .leading, spacing: 0){
                        VStack(spacing: 0){
                            Text("커뮤니티 오픈까지🔥")
                                .font(.system(size: 10, weight: .bold))
                                .padding(.bottom, 5)
                                .padding(.leading, 5)
                            ZStack(alignment: .center){
                                MessageBoxShape()
                                    .fill(Color("Grey900"))
                                    .frame(width: 70, height: 50)
                                Text("\(self.currentUser.formatted())명")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Color("Pink Main"))
                                    .padding(.bottom, 9)
                            }
                            .frame(width: 70, height: 50)
                        }
                        .padding(.leading, (proxy.size.width - 64) * self.percent - 55)
                        .padding(.bottom, 6)
                        ZStack(alignment: .leading){
                            Capsule()
                                .foregroundColor(Color("ProgressBar Color"))
                                .frame(width: proxy.size.width - 64, height : 40)
                                .frame(minWidth: 0,
                                       maxWidth: .infinity
                                )
                                .overlay(
                                    Capsule()
                                        .fill(LinearGradient(gradient: Gradient(colors: [Color("MainGradient1"), Color("MainGradient2"),Color("MainGradient3")]),
                                                             startPoint: .trailing, endPoint: .leading))
                                        .frame(width: (proxy.size.width - 64) * self.percent, height: 40)
                                    ,alignment: .leading
                                )
                                .overlay(
                                    Capsule()
                                       .stroke(Color(red: 236/255, green: 234/255, blue: 235/255),
                                               lineWidth: 3)
                                       .shadow(color: Color(red: 192/255, green: 189/255, blue: 191/255),
                                               radius: 3, x: 1.5, y: 1.5)
                                       .clipShape(
                                           Capsule()
                                       )
                                )
                        }
                    }
                    .padding(.top, 60)
                    .padding([.leading, .trailing], 32)
                    VStack(alignment: .leading, spacing: 10){
                        HStack(spacing : 0){
                            Text("10,000명")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color("Main Primary"))
                            Text("이 Chatty를 사용하면")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color("Pink Main"))
                        }
                        Text("커뮤니티 탭이 열려요!")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color("Main Primary"))
                    }
                    .padding(.top, 32)
                    .padding(.leading, 32)
                    Spacer()
                }
                .background(Color.clear)
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .onAppear{
            chattyVM.currentUser()
        }
        .onReceive(chattyVM.$currentUserModel){ data in
            self.currentUser = data?.info ?? 0
            self.percent = Double(self.currentUser) / 10000
            if self.percent < 0.15 {
                self.percent = 0.15
            }
        }
    }
}

struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView().environmentObject(ChattyVM())
    }
}
