//
//  RegisterView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2022/12/22.
//

import SwiftUI

struct RegisterView: View {
    
    @EnvironmentObject var userVM: UserVM
    
    @State
    private var username = ""
    
    @State
    private var email = ""
    
    @State
    private var password = ""
    
    @State
    private var togglePassword : Bool = true
    
    @State
    private var password2 = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            Color.white
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
                    .foregroundColor(Color("Black"))
                    .padding(.leading, 30)
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
                        Text("이메일")
                            .font(.system(size:12))
                            .fontWeight(.light)
                        HStack {
                            TextField("이메일", text: $email)
                                .frame(height: 25)
                                .padding()
                                .background(Color(uiColor: .secondarySystemBackground))
                                .mask(RoundedRectangle(cornerRadius: 16))
                                .padding(.bottom, 20)
                        }
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
                            Image(systemName: self.togglePassword ? "eye": "eye.slash")
                                .foregroundColor(Color(.lightGray))
                                .font(Font.system(size: 20))
                                .padding([.bottom, .trailing], 18)
                                .onTapGesture(perform: {
                                    togglePassword.toggle()
                                })
                        }
                        Text("비밀번호 확인")
                            .font(.system(size:12))
                            .fontWeight(.light)
                        SecureField("비밀번호 확인", text: $password2)
                            .frame(height: 25)
                            .padding()
                            .background(Color(uiColor: .secondarySystemBackground))
                            .mask(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.leading, 30)
                    .padding(.trailing, 30)
                }
                Spacer()
                VStack {
                    Button(action: {userVM.register(username: username, password: password, password2: password2, email: email)}) {
                        Text("회원가입")
                            .fontWeight(.bold)
                            .frame(width: 330, height: 60)
                            .foregroundColor(Color("White"))
                            .background(Color("Main Color"))
                            .cornerRadius(16)
                            .padding(.bottom, 20)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onTapGesture {
            endEditing()
        }
    }
    
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView().environmentObject(UserVM())
    }
}
