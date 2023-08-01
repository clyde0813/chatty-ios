//
//  RegisterVM.swift
//  Chatty
//
//  Created by Clyde on 2023/05/30.
//

import Alamofire
import Combine
import Foundation


class RegisterVM : ObservableObject{
    
    @Published var errorModel : ErrorModel? = nil
    
    //MARK: - input
    @Published var username = ""
    
    @Published var profile_name = ""
    
    @Published var email = ""
    
    @Published var password = ""
    
    @Published var password2 = ""
    
    //MARK: - Verify
    @Published var usernameVerify = false
    
    @Published var emailVerify = false
    
    @Published var registerSuccess = false
    
    
    
    func verifyUsername(){
        AuthorizationService.share.verifyUsername(username: username) { result in
            if result{
                self.usernameVerify = true
            }else{
                ChattyEventManager.share.showAlter.send("사용할 수 없는 아이디입니다.")
            }
        }
    }
    
    func verifyEmail(){
        AuthorizationService.share.verifyEmail(email: email) { result in
            if result {
                self.emailVerify = true
            }else{
                ChattyEventManager.share.showAlter.send("사용할 수 없는 이메일입니다.")
            }
        }
    }
    
    func checkRegister() -> Bool{
        //아이디 이메일 중복여부 체크
        //아이디 >= 4 && 아이디<=20
        //닉네임 >=1 && 닉네임 <=20
        //비밀번호1,2 같고 && 비밀번호 >=4 && 비밀번호 <=20
        
        if usernameVerify && emailVerify && 4 <= username.count && username.count <= 20 && 1 <= profile_name.count && profile_name.count <= 20 && 4 <= password.count && password.count <= 20 && self.password == self.password2{
            return false
        } else {
            return true
        }
    }
    
    //MARK: - 회원가입
    func register(){
        AuthorizationService.share.register(username: username, profilename: profile_name, email: email, password: password, password2: password2)
    }
    
    
}
