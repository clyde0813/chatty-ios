//
//  RegisterView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2022/12/22.
//

import SwiftUI

struct RegisterView: View {
    @State
    private var username = ""
    
    @State
    private var password = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    VStack(alignment: .leading) {
                        VStack(alignment:.leading) {
                                HStack{
                                    Button(action: {presentationMode.wrappedValue.dismiss()}) {
//                                    Button(action: {makeGetCall()}) {
                                        Image(systemName: "chevron.backward")
                                            .font(Font.system(size: 20, weight: .bold))
                                        Text("회원가입")
                                            .font(.system(size: 20))
                                            .fontWeight(.bold)
                                            .padding()
                                    }
                                }
                                .foregroundColor(Color("Black"))
                                .padding(.bottom, 10)
                                Text("아이디")
                                .font(.system(size:12))
                                .fontWeight(.light)
                                TextField("아이디", text: $username)
                                    .frame(width: 300)
                                    .padding()
                                    .background(Color(uiColor: .secondarySystemBackground))
                                    .mask(RoundedRectangle(cornerRadius: 16))
                                    .padding(.bottom, 20)
                                Text("이메일")
                                .font(.system(size:12))
                                .fontWeight(.light)
                                HStack {
                                    TextField("이메일", text: $username)
                                        .frame(width: 300)
                                        .padding()
                                        .background(Color(uiColor: .secondarySystemBackground))
                                        .mask(RoundedRectangle(cornerRadius: 16))
                                        .padding(.bottom, 20)
                                    Rectangle()
                                        .frame(width: 80)
                                }
                                Text("비밀번호")
                                .font(.system(size:12))
                                .fontWeight(.light)
                                SecureField("비밀번호", text: $password)
                                    .frame(width: 300)
                                    .padding()
                                    .background(Color(uiColor: .secondarySystemBackground))
                                    .mask(RoundedRectangle(cornerRadius: 16))
                                    .padding(.bottom, 20)
                                Text("비밀번호 확인")
                                .font(.system(size:12))
                                .fontWeight(.light)
                                SecureField("비밀번호 확인", text: $password)
                                    .frame(width: 300)
                                    .padding()
                                    .background(Color(uiColor: .secondarySystemBackground))
                                    .mask(RoundedRectangle(cornerRadius: 16))

                        }
                        Spacer()
                        VStack {
                                Text("회원가입")
                                    .fontWeight(.bold)
                                    .frame(width: 350, height: 60)
                                    .foregroundColor(Color("White"))
                                    .background(Color("Main Color"))
                                    .cornerRadius(16)
                                    .padding(.bottom, 20)
                        }
                    }
                }
            }
        }
        .ignoresSafeArea(.all)
        .navigationBarHidden(true)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
