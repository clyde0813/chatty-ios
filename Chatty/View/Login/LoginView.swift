//
//  LoginView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2022/12/21.
//

import SwiftUI


struct LoginView: View {
    
    @StateObject var loginVM = LoginVM()
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    //MARK: - 뷰상태 관련 프로퍼티
    @State private var loginPressed = false
    
    @State private var loginSuccess = false
    
    @State private var ErrorShow = false
    
    @State private var isShowPassword = true
    
    @GestureState private var dragOffset = CGSize.zero
    
    //MARK: - 메인뷰
    var body: some View {
        
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
                        
                        ScrollView{
                            VStack(alignment: .leading){
                                Text("아이디")
                                    .font(.system(size:12))
                                    .fontWeight(.light)
                                TextField("아이디를 입력해 주세요.", text: $loginVM.username)
                                    .frame(height: 25)
                                    .padding()
                                    .background(Color(uiColor: .secondarySystemBackground))
                                    .mask(RoundedRectangle(cornerRadius: 16))
                                    .padding(.bottom, 20)
                                Text("비밀번호")
                                    .font(.system(size:12))
                                    .fontWeight(.light)
                                ZStack(alignment: .trailing){
                                    if isShowPassword {
                                        SecureField("비밀번호", text: $loginVM.password)
                                            .frame(height: 25)
                                            .padding()
                                            .background(Color(uiColor: .secondarySystemBackground))
                                            .mask(RoundedRectangle(cornerRadius: 16))
                                            .padding(.bottom, 20)
                                    } else {
                                        TextField("비밀번호", text: $loginVM.password)
                                            .frame(height: 25)
                                            .padding()
                                            .background(Color(uiColor: .secondarySystemBackground))
                                            .mask(RoundedRectangle(cornerRadius: 16))
                                            .padding(.bottom, 20)
                                    }
                                    Image(systemName: isShowPassword ? "eye.fill": "eye.slash.fill")
                                        .foregroundColor(Color(.lightGray))
                                        .font(Font.system(size: 20))
                                        .padding([.bottom, .trailing], 18)
                                        .onTapGesture(perform: {
                                            isShowPassword.toggle()
                                        })
                                }
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
                            loginVM.login()
                        }){
                            Text("로그인")
                                .fontWeight(.bold)
                                .frame(height: 60)
                                .frame(minWidth: 0,
                                       maxWidth: .infinity
                                )
                                .foregroundColor(Color.white)
                                .background(loginVM.username.isEmpty || loginVM.password.isEmpty ? Color("Grey500") : Color("Main Primary"))
                                .cornerRadius(16)
                                .padding(.bottom, 20)
                        }
                        .disabled(loginVM.username.isEmpty || loginVM.password.isEmpty ? true : false)
                    }
                    .padding([.leading, .trailing], 20)
                }
                
                
                .navigationBarHidden(true)
                
                if ErrorShow{
                    ErrorView(message: "아이디 또는 비밀번호가 일치하지 않습니다.")
                }
                
            }
            .onReceive(loginVM.isLoginSuccess, perform: { result in
                if result {
                    loginSuccess = true
                    let window = UIApplication
                        .shared
                        .connectedScenes
                        .flatMap { ($0 as? UIWindowScene)?.windows ?? []
                        }
                        .first{ $0.isKeyWindow}
                    window?.rootViewController = UIHostingController(rootView: MainView().environmentObject(ChattyVM()))
                    window?.makeKeyAndVisible()
                }else{
                    loginPressed = false
                    ErrorShow = true
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                        ErrorShow = false
                    }
                }
                
            })
            
            .onTapGesture {
                endEditing()
            }
        }
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.startLocation.x < 20 && value.translation.width > 100) {
                dismiss()
            }
        }))
        
        
    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
