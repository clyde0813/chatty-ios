//
//  RegisterView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2022/12/22.
//

import SwiftUI

struct RegisterView: View {
    
    //2023.05.15 신현호
    @StateObject var registerVM = RegisterVM()
    
    @State private var togglePassword : Bool = true

    @State private var registerPressed : Bool = false
    
    @State var msg = ""
    
    @State var showMsg = false
        
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.dismiss) private var dismiss
    
    @GestureState private var dragOffset = CGSize.zero

    
    var body: some View {
        
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
                    ScrollView{
                        VStack(alignment: .leading){
                            
                            VStack(alignment: .leading, spacing: 0){
                                Text("아이디")
                                    .font(.system(size:12))
                                    .fontWeight(.light)
                                    .padding(.bottom, 10)
                                ZStack(alignment: .trailing){
                                    TextField("아이디 4글자 이상 20글자 이하", text: $registerVM.username)
                                        .frame(minWidth: 0,
                                               maxWidth: .infinity
                                        )
                                        .padding()
                                        .background(Color(uiColor: .secondarySystemBackground))
                                        .mask(RoundedRectangle(cornerRadius: 16))
                                        .disabled(registerVM.usernameVerify)
                                    Button(action: {
                                        registerVM.verifyUsername()
                                    }){
                                        if registerVM.usernameVerify {
                                            Image(systemName: "checkmark.seal.fill")
                                                .font(.system(size:13, weight: .semibold))
                                                .frame(width: 60, height: 15)
                                                .foregroundColor(Color.white)
                                                .padding(.vertical,10)
                                                .padding(.horizontal)
                                                .background(
                                                    Capsule()
                                                        .fill(Color("MainGradient2"))
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
                                    .disabled(registerVM.usernameVerify || registerVM.username.count < 4 || registerVM.username.count > 15)
                                    
                                }
                            }
                            .padding(.bottom, 20)
                            
                            
                            VStack(alignment: .leading, spacing: 0){
                                Text("닉네임")
                                    .font(.system(size:12))
                                    .fontWeight(.light)
                                    .padding(.bottom, 10)
                                TextField("닉네임 1글자 이상 20글자 이하", text: $registerVM.profile_name)
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
                                    TextField("이메일", text: $registerVM.email)
                                        .padding()
                                        .background(Color(uiColor: .secondarySystemBackground))
                                        .mask(RoundedRectangle(cornerRadius: 16))
                                        .disabled(registerVM.emailVerify)
                                    Button(action: {
                                        registerVM.verifyEmail()
                                    }){
                                        if registerVM.emailVerify {
                                            Image(systemName: "checkmark.seal.fill")
                                                .font(.system(size:13, weight: .semibold))
                                                .frame(width: 60, height: 15)
                                                .foregroundColor(Color.white)
                                                .padding(.vertical,10)
                                                .padding(.horizontal)
                                                .background(
                                                    Capsule()
                                                        .fill(Color("MainGradient2"))
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
                                    .disabled(registerVM.emailVerify || registerVM.email.count < 1)
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
                                        SecureField("비밀번호 4글자 이상 20글자 이하", text: $registerVM.password)
                                            .padding()
                                            .background(Color(uiColor: .secondarySystemBackground))
                                            .mask(RoundedRectangle(cornerRadius: 16))
                                    } else {
                                        TextField("비밀번호 4글자 이상 20글자 이하", text: $registerVM.password)
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
                                SecureField("비밀번호 확인", text: $registerVM.password2)
                                    .frame(height: 25)
                                    .padding()
                                    .background(Color(uiColor: .secondarySystemBackground))
                                    .mask(RoundedRectangle(cornerRadius: 16))
                            }
                        }
                    }
                    
                }
                Spacer()
                VStack {
                    Button(action: {
                        self.registerPressed = true
                        registerVM.register()
                    }) {
                        Text("회원가입")
                            .fontWeight(.bold)
                            .frame(height: 60)
                            .frame(minWidth: 0,
                                   maxWidth: .infinity
                            )
                            .foregroundColor(Color.white)
                            .background(registerVM.checkRegister() ? Color("Grey500") : Color("Main Primary"))
                            .cornerRadius(16)
                            .padding(.bottom, 20)
                    }
                    .disabled(registerVM.checkRegister())
                }
            }
            
            .padding([.leading, .trailing], 20)
            .navigationBarHidden(true)
            
            if showMsg {
                ErrorView(message: msg)
            }
        }
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.startLocation.x < 20 && value.translation.width > 100) {
                dismiss()
            }
        }))
        .onTapGesture {
            endEditing()
        }
        .onReceive(ChattyEventManager.share.showAlter, perform: { result in
            msg = result
            showMsg = true
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                showMsg = false
            }
        })

        
    }
}



struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
