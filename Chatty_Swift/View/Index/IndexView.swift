//
//  IndexView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2022/12/21.
//

import SwiftUI

struct IndexView: View {
    @EnvironmentObject var chattyVM: ChattyVM

    var body: some View {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            MainView()
        } else {
            NavigationStack {
                GeometryReader{ proxy in
                    ZStack{
                        Color.white
                        VStack(spacing:0){
                            VStack(alignment: .leading, spacing: 16){
                                Text("안녕!")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(Color("Main Primary"))
                                Text("자유로운 우리를 봐,")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(Color("Pink Main"))
                                HStack(spacing: 0){
                                    Text("Chatty ")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(Color("Main Primary"))
                                    Text("예요!")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(Color("Pink Main"))
                                    Spacer()
                                }
                            }
                            .padding(.top, 116)
                            .padding(.leading, 30)
                            Spacer()
                            VStack(spacing: 0){
                                NavigationLink(destination: LoginView()){
                                    Text("Chatty 로그인")
                                        .font(.system(size: 16, weight: .bold))
                                        .frame(height: 60)
                                        .frame(
                                            minWidth: 0,
                                            maxWidth: .infinity
                                        )
                                        .foregroundColor(Color.white)
                                        .background(Color("Main Primary"))
                                        .cornerRadius(6)
                                }
                                .padding(.bottom, 16)
                                Text("앗, 회원이 아니라면?")
                                    .font(.system(size: 16, weight: .none))
                                    .padding(.bottom, 8)
                                NavigationLink(destination: RegisterView()){
                                    Text("박박 빠르게 회원가입하기 →")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(Color("Main Primary"))
                                }
                            }
                            .padding([.leading, .trailing], 16)
                            .padding(.bottom, 60)
                        }
                    }
                    .ignoresSafeArea(.all)
                }
            }
            .navigationBarHidden(true)
            .onAppear{
                chattyVM.apnsTokenInitialize(){success in
                    
                }
            }
        }
    }
}

struct IndexView_Previews: PreviewProvider {
    static var previews: some View {
        IndexView().environmentObject(ChattyVM())
    }
}
