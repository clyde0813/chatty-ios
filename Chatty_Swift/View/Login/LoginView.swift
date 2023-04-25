//
//  LoginView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2022/12/21.
//

import SwiftUI


struct LoginView: View {
    
    @EnvironmentObject var chattyVM: ChattyVM
    
    @Environment(\.dismiss) var dismiss
    
    @State
    private var username = ""
    
    @State
    private var password = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var loginPressed = false
        
    @State private var loginSuccess = false
    
    @State private var loginError = false
    
    @State private var togglePassword = true
    
    var body: some View {
        if self.loginSuccess || UserDefaults.standard.bool(forKey: "isLoggedIn"){
            MainView()
        } else {
            GeometryReader{proxy in
                ZStack(alignment: .center) {
                    Color.white
                    if self.loginPressed {
                        ProgressView("로그인 중...")
                    }
                    VStack{
                        VStack(alignment: .leading) {
                            HStack{
                                Button(action:{
                                    presentationMode.wrappedValue.dismiss()
                                    
                                }) {
                                    Image(systemName: "chevron.backward")
                                        .font(Font.system(size: 20, weight: .bold))
                                    Text("로그인")
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                        .padding()
                                }
                            }
                            .foregroundColor(Color.black)
                            VStack(alignment: .leading){
                                Text("아이디")
                                    .font(.system(size:12))
                                    .fontWeight(.light)
                                TextField("아이디를 입력해 주세요.", text: $username)
                                    .frame(height: 25)
                                    .padding()
                                    .background(Color(uiColor: .secondarySystemBackground))
                                    .mask(RoundedRectangle(cornerRadius: 16))
                                    .padding(.bottom, 20)
                                Text("비밀번호")
                                    .font(.system(size:12))
                                    .fontWeight(.light)
                                ZStack(alignment: .trailing){
                                    if togglePassword == true {
                                        SecureField("비밀번호", text: $password)
                                            .frame(height: 25)
                                            .padding()
                                            .background(Color(uiColor: .secondarySystemBackground))
                                            .mask(RoundedRectangle(cornerRadius: 16))
                                            .padding(.bottom, 20)
                                    } else {
                                        TextField("비밀번호", text: $password)
                                            .frame(height: 25)
                                            .padding()
                                            .background(Color(uiColor: .secondarySystemBackground))
                                            .mask(RoundedRectangle(cornerRadius: 16))
                                            .padding(.bottom, 20)
                                    }
                                    Image(systemName: self.togglePassword ? "eye.fill": "eye.slash.fill")
                                        .foregroundColor(Color(.lightGray))
                                        .font(Font.system(size: 20))
                                        .padding([.bottom, .trailing], 18)
                                        .onTapGesture(perform: {
                                            togglePassword.toggle()
                                        })
                                }
                            }
                        }
                        .padding([.leading, .trailing], 20)
                        Spacer()
                        VStack {
//                            HStack {
//                                Text("계정 정보 찾기")
//                                    .font(.system(size: 16))
//                                Image(systemName: "chevron.forward")
//                                    .font(Font.system(size: 16))
//                            }
//                            .padding(16)
                            Button(action: {
                                endEditing()
                                self.loginPressed = true
                                chattyVM.login(username: username, password: password)
                            }){
                                Text("로그인")
                                    .fontWeight(.bold)
                                    .frame(height: 60)
                                    .frame(minWidth: 0,
                                           maxWidth: .infinity
                                    )
                                    .foregroundColor(Color.white)
                                    .background(self.username.isEmpty || self.password.isEmpty ? Color("Grey500") : Color("Main Primary"))
                                    .cornerRadius(16)
                                    .padding(.bottom, 20)
                            }
                            .disabled(self.username.isEmpty || self.password.isEmpty ? true : false)
                        }
                        .padding([.leading, .trailing], 20)
                    }
                    .navigationBarHidden(true)
                    
                    if self.loginError{
                        Text("아이디 또는 비밀번호가 일치하지 않습니다.")
                            .frame(width: 310, height: 40)
                            .foregroundColor(Color.white)
                            .background(Color.gray)
                            .cornerRadius(16)
                            .padding(.top, 400)
                    }
                    
                }
                .onReceive(chattyVM.loginSuccess, perform: {
                    self.loginSuccess = true
                })
                .onReceive(chattyVM.loginError) {
                    self.loginError = true
                    self.loginPressed = false
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                        self.loginError = false
                    }
                }
                .onTapGesture {
                    endEditing()
                }
            }
        }
    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(ChattyVM())
    }
}


