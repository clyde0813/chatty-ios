//
//  LoginView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2022/12/21.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var userVM: UserVM
    
    @State
    private var username = ""
    
    @State
    private var password = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView() {
                VStack {
                    VStack(alignment: .leading) {
                        VStack(alignment:.leading) {
                            HStack{
                                Button(action: {presentationMode.wrappedValue.dismiss()}) {
                                    //                                    Button(action: {makeGetCall()}) {
                                    Image(systemName: "chevron.backward")
                                        .font(Font.system(size: 20, weight: .bold))
                                    Text("로그인")
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                        .padding()
                                }
                            }
                            .padding(.leading, 30)
                            .foregroundColor(Color("Black"))
                            VStack(alignment: .leading){
                                Text("아이디")
                                    .font(.system(size:12))
                                    .fontWeight(.light)
                                TextField("아이디", text: $username)
                                    .padding()
                                    .background(Color(uiColor: .secondarySystemBackground))
                                    .mask(RoundedRectangle(cornerRadius: 16))
                                    .padding(.bottom, 20)
                                Text("비밀번호")
                                    .font(.system(size:12))
                                    .fontWeight(.light)
                                SecureField("비밀번호", text: $password)
                                    .padding()
                                    .background(Color(uiColor: .secondarySystemBackground))
                                    .mask(RoundedRectangle(cornerRadius: 16))
                            }
                            .padding(.leading, 30)
                            .padding(.trailing, 30)
                        }
                    }
                    Spacer()
                    VStack {
                        HStack {
                            Text("계정 정보 찾기")
                                .font(.system(size: 16))
                            Image(systemName: "chevron.forward")
                                .font(Font.system(size: 16))
                        }
                        .padding(16)
                        Button(action: {userVM.login(username: username, password: password)}){
                            Text("로그인")
                                .fontWeight(.bold)
                                .frame(width: 350, height: 60)
                                .foregroundColor(Color("White"))
                                .background(Color("Button Grey 2"))
                                .cornerRadius(16)
                                .padding(.bottom, 20)
                            //                                }
                        }
                    }
                }
            
        }
        .ignoresSafeArea(.all)
        .navigationBarHidden(true)
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
