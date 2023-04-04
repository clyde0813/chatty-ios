//
//  LoginView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2022/12/21.
//

import SwiftUI


struct LoginView: View {
    
    @EnvironmentObject var userVM: UserVM
    
    @Environment(\.dismiss) var dismiss
    
    @State
    private var username = ""
    
    @State
    private var password = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var loginPressed = false
    
    @State private var shouldAnimate = false
    
    var body: some View {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            MainView()
        } else {
            ZStack {
                Color.white
                if self.loginPressed {
                    HStack {
                        Circle()
                            .fill(Color("Main Color"))
                            .frame(width: 20, height: 20)
                            .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                            .animation(Animation.easeInOut(duration: 0.5).repeatForever(), value: shouldAnimate)
                        Circle()
                            .fill(Color("Main Color"))
                            .frame(width: 20, height: 20)
                            .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                            .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.3), value: shouldAnimate)
                        Circle()
                            .fill(Color("Main Color"))
                            .frame(width: 20, height: 20)
                            .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                            .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.6), value: shouldAnimate)
                    }
                    .onAppear{
                        self.shouldAnimate = true
                    }
                }
                VStack{
                    VStack(alignment: .leading) {
                        HStack{
                            Button(action: {presentationMode.wrappedValue.dismiss()}) {
                                Image(systemName: "chevron.backward")
                                    .font(Font.system(size: 20, weight: .bold))
                                Text("로그인")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                    .padding()
                            }
                        }
                        .foregroundColor(Color("Black"))
                        VStack(alignment: .leading){
                            Text("아이디")
                                .font(.system(size:12))
                                .fontWeight(.light)
                            TextField("아이디", text: $username)
                                .frame(height: 25)
                                .padding()
                                .background(Color(uiColor: .secondarySystemBackground))
                                .mask(RoundedRectangle(cornerRadius: 16))
                                .padding(.bottom, 20)
                            Text("비밀번호")
                                .font(.system(size:12))
                                .fontWeight(.light)
                            SecureField("비밀번호", text: $password)
                                .frame(height: 25)
                                .padding()
                                .background(Color(uiColor: .secondarySystemBackground))
                                .mask(RoundedRectangle(cornerRadius: 16))
                        }
                    }
                    .padding([.leading, .trailing], 30)
                    Spacer()
                    VStack {
                        HStack {
                            Text("계정 정보 찾기")
                                .font(.system(size: 16))
                            Image(systemName: "chevron.forward")
                                .font(Font.system(size: 16))
                        }
                        .padding(16)
                        Button(action: {
                            endEditing()
                            self.loginPressed = true
                            userVM.login(username: username, password: password)
                        }){
                            Text("로그인")
                                .fontWeight(.bold)
                                .frame(width: 330, height: 60)
                                .foregroundColor(Color("White"))
                                .background(Color("Main Color"))
                                .cornerRadius(16)
                                .padding(.bottom, 20)
                        }
                    }
                }
                .onReceive(userVM.loginSuccess, perform: {
                    print("LoginView - loginSuccess() called")
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    
                })
                .navigationBarHidden(true)
            }
            .onTapGesture {
                endEditing()
            }
        }
    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(UserVM())
    }
}


