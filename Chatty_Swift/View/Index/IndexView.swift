//
//  IndexView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2022/12/21.
//

import SwiftUI

struct IndexView: View {
    var body: some View {
        NavigationView() {
            ZStack {
                Color("Main Color").edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    ZStack{
                        Image("Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150)
                    }
                    Spacer()
                    VStack {
                        NavigationLink(destination: LoginView()){
                            Text("로그인")
                                .fontWeight(.bold)
                                .frame(width: 350, height: 60)
                                .foregroundColor(Color.white)
                                .background(Color("Main Color"))
                                .cornerRadius(16)
                        }
                        NavigationLink(destination: RegisterView()){
                            Text("회원가입")
                                .fontWeight(.bold)
                                .frame(width: 350, height: 60)
                                .foregroundColor(Color("Main Color"))
                                .background(Color("Button Grey"))
                                .cornerRadius(16)
                        }
                        .padding(3)
                    }
                    .frame(width: 500, height: 180)
                    .background(Color.white)
                    .ignoresSafeArea(.all)
                }
            }
        }
    }
}

struct IndexView_Previews: PreviewProvider {
    static var previews: some View {
        IndexView()
    }
}
