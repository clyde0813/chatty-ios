//
//  RegisterView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2022/12/22.
//

import SwiftUI

struct RegisterView: View {
    
    @EnvironmentObject var chattyVM: ChattyVM
    
    @State
    private var username = ""
    
    @State
    private var profile_name = ""
    
    @State
    private var email = ""
    
    @State
    private var password = ""
    
    @State
    private var password2 = ""
    
    @State
    private var togglePassword : Bool = true
    
    @State
    private var usernameVerify : Bool = false
    
    @State
    private var emailVerify : Bool = false
    
    @State
    private var registerPressed : Bool = false
    
    @State
    private var registerSuccess : Bool = false
    
    @State
    private var registerError : Bool = false
    
    @State
    private var usernameError : Bool = false
    
    @State
    private var emailError : Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        if self.registerSuccess || UserDefaults.standard.bool(forKey: "isLoggedIn"){
            MainView()
        } else {
            ZStack{
                Color.white
                if self.registerPressed{
                    ProgressView("회원가입 중...")
                        .zIndex(1)
                        .padding(.bottom, 60)
                }
                VStack {
                    VStack(alignment:.leading) {
                        HStack{
                            Button(action: {presentationMode.wrappedValue.dismiss()}) {
                                Image(systemName: "chevron.backward")
                                    .font(Font.system(size: 20, weight: .bold))
                                Text("회원가입")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                    .padding()
                            }
                        }
                        .foregroundColor(Color.black)
                        VStack(alignment: .leading){
                            
                            VStack(alignment: .leading, spacing: 0){
                                Text("아이디")
                                    .font(.system(size:12))
                                    .fontWeight(.light)
                                    .padding(.bottom, 10)
                                ZStack(alignment: .trailing){
                                    TextField("아이디 4글자 이상 20글자 이하", text: $username)
                                        .frame(minWidth: 0,
                                               maxWidth: .infinity
                                        )
                                        .padding()
                                        .background(Color(uiColor: .secondarySystemBackground))
                                        .mask(RoundedRectangle(cornerRadius: 16))
                                        .disabled(usernameVerify)
                                    Button(action: {
                                        chattyVM.verifyUsername(username: username)
                                    }){
                                        if usernameVerify {
                                            Image(systemName: "checkmark.seal.fill")
                                                .font(.system(size:13, weight: .semibold))
                                                .frame(width: 60, height: 15)
                                                .foregroundColor(Color.white)
                                                .padding(.vertical,10)
                                                .padding(.horizontal)
                                                .background(
                                                    Capsule()
                                                        .fill(Color("Pink Main"))
                                                )
                                                .padding(.trailing, 16)
                                        } else {
                                            Text("중복확인")
                                                .font(.system(size:13, weight: .semibold))
                                                .frame(width: 60, height: 15)
                                                .foregroundColor(Color.white)
                                                .padding(.vertical,10)
                                                .padding(.horizontal)
                                                .background(
                                                    Capsule()
                                                        .fill(Color("Pink Main"))
                                                )
                                                .padding(.trailing, 16)
                                        }
                                    }
                                    .disabled(usernameVerify || self.username.isEmpty || self.username.count < 4 || self.username.count > 15)
                                }
                            }
                            .padding(.bottom, 20)
                            
                            
                            VStack(alignment: .leading, spacing: 0){
                                Text("닉네임")
                                    .font(.system(size:12))
                                    .fontWeight(.light)
                                    .padding(.bottom, 10)
                                TextField("닉네임 1글자 이상 20글자 이하", text: $profile_name)
                                    .padding()
                                    .background(Color(uiColor: .secondarySystemBackground))
                                    .mask(RoundedRectangle(cornerRadius: 16))
                            }
                            .padding(.bottom, 20)
                            
                            VStack(alignment: .leading, spacing: 0){
                                Text("이메일")
                                    .font(.system(size:12))
                                    .fontWeight(.light)
                                    .padding(.bottom, 10)
                                ZStack(alignment: .trailing) {
                                    TextField("이메일", text: $email)
                                        .padding()
                                        .background(Color(uiColor: .secondarySystemBackground))
                                        .mask(RoundedRectangle(cornerRadius: 16))
                                        .disabled(emailVerify)
                                    Button(action: {
                                        chattyVM.verifyEmail(email: email)
                                    }){
                                        if emailVerify {
                                            Image(systemName: "checkmark.seal.fill")
                                                .font(.system(size:13, weight: .semibold))
                                                .frame(width: 60, height: 15)
                                                .foregroundColor(Color.white)
                                                .padding(.vertical,10)
                                                .padding(.horizontal)
                                                .background(
                                                    Capsule()
                                                        .fill(Color("Pink Main"))
                                                )
                                                .padding(.trailing, 16)
                                        } else {
                                            Text("이메일 확인")
                                                .font(.system(size:13, weight: .semibold))
                                                .frame(width: 60, height: 15)
                                                .foregroundColor(Color.white)
                                                .padding(.vertical,10)
                                                .padding(.horizontal)
                                                .background(
                                                    Capsule()
                                                        .fill(Color("Pink Main"))
                                                )
                                                .padding(.trailing, 16)
                                        }
                                    }
                                    .disabled(emailVerify || self.email.isEmpty)
                                }
                            }
                            .padding(.bottom, 20)
                            
                            VStack(alignment: .leading, spacing: 0){
                                Text("비밀번호")
                                    .font(.system(size:12))
                                    .fontWeight(.light)
                                    .padding(.bottom, 10)
                                ZStack(alignment: .trailing){
                                    if togglePassword == true {
                                        SecureField("비밀번호 4글자 이상 20글자 이하", text: $password)
                                            .padding()
                                            .background(Color(uiColor: .secondarySystemBackground))
                                            .mask(RoundedRectangle(cornerRadius: 16))
                                    } else {
                                        TextField("비밀번호 4글자 이상 20글자 이하", text: $password)
                                            .frame(height: 25)
                                            .padding()
                                            .background(Color(uiColor: .secondarySystemBackground))
                                            .mask(RoundedRectangle(cornerRadius: 16))
                                    }
                                    Image(systemName: self.togglePassword ? "eye.fill": "eye.slash.fill")
                                        .foregroundColor(Color(.lightGray))
                                        .font(Font.system(size: 20))
                                        .padding([.trailing], 18)
                                        .onTapGesture(perform: {
                                            togglePassword.toggle()
                                        })
                                }
                            }
                            .padding(.bottom, 20)
                            
                            VStack(alignment: .leading, spacing: 0){
                                Text("비밀번호 확인")
                                    .font(.system(size:12))
                                    .fontWeight(.light)
                                    .padding(.bottom, 10)
                                SecureField("비밀번호 확인", text: $password2)
                                    .frame(height: 25)
                                    .padding()
                                    .background(Color(uiColor: .secondarySystemBackground))
                                    .mask(RoundedRectangle(cornerRadius: 16))
                            }
                        }
                    }
                    Spacer()
                    VStack {
                        Button(action: {
                            self.registerPressed = true
                            chattyVM.register(username: username, profile_name: profile_name, email: email, password: password, password2: password2)
                        }) {
                            Text("회원가입")
                                .fontWeight(.bold)
                                .frame(height: 60)
                                .frame(minWidth: 0,
                                       maxWidth: .infinity
                                )
                                .foregroundColor(Color.white)
                                .background(dataVerify() ? Color("Grey500") : Color("Main Primary"))
                                .cornerRadius(16)
                                .padding(.bottom, 20)
                        }
                        .disabled(dataVerify())
                    }
                }
                .padding([.leading, .trailing], 20)
                .navigationBarHidden(true)
                if self.registerError{
                    VStack{
                        Spacer()
                        Text("\(chattyVM.errorModel?.error ?? "")")
                            .frame(width: 310, height: 40)
                            .foregroundColor(Color.white)
                            .background(Color("Error Background"))
                            .cornerRadius(16)
                            .padding(.bottom, 100)
                    }
                }
                if self.usernameError{
                    VStack{
                        Spacer()
                        Text("사용 불가능한 아이디입니다.")
                            .frame(width: 310, height: 40)
                            .foregroundColor(Color.white)
                            .background(Color("Error Background"))
                            .cornerRadius(16)
                            .padding(.bottom, 100)
                    }
                }
                if self.emailError{
                    VStack{
                        Spacer()
                        Text("사용 불가능한 이메일입니다.")
                            .frame(width: 310, height: 40)
                            .foregroundColor(Color.white)
                            .background(Color("Error Background"))
                            .cornerRadius(16)
                            .padding(.bottom, 100)
                    }
                }
            }
            .onTapGesture {
                endEditing()
            }
            .onReceive(chattyVM.usernameAvailable){
                self.usernameVerify = true
            }
            .onReceive(chattyVM.usernameUnavailable){
                self.usernameError = true
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                    self.usernameError = false
                }
            }
            .onReceive(chattyVM.emailAvailable){
                self.emailVerify = true
            }
            .onReceive(chattyVM.emailUnavailable){
                self.emailError = true
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                    self.emailError = false
                }
            }
            .onReceive(chattyVM.registerSuccess){
                self.registerSuccess = true
                self.registerPressed = false
            }
            .onReceive(chattyVM.registerError){
                self.registerError = true
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                    self.registerError = false
                }
            }
        }
    }
    func dataVerify()-> Bool {
        if !self.profile_name.isEmpty && !self.email.isEmpty && !self.username.isEmpty && !self.password.isEmpty && !self.password2.isEmpty && self.usernameVerify && self.emailVerify && 4 <= self.username.count && self.username.count <= 20 && 1 <= profile_name.count && profile_name.count <= 20 && 4 <= self.password.count && self.password.count <= 20 && self.password == self.password2{
            return false
        } else {
            return true
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView().environmentObject(ChattyVM())
    }
}
