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
    
    var username_available = PassthroughSubject<Bool, Never>()
    
    var email_available = PassthroughSubject<Bool, Never>()
    
    var register_available = PassthroughSubject<Bool, Never>()
    
    
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
    
    
    //MARK: - 중복여부 확인
    func verifyUsername(){
        let url = "https://chatty.kr/api/v1/user/profile/\(username)"
        
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
        .response { response in
            switch response.response?.statusCode {
            case 200:
                self.username_available.send(false)
            case 400:
                self.username_available.send(true)
            default:
                self.username_available.send(false)
            }
        }
    }
    
    func verifyEmail(){
        let url = "https://chatty.kr/api/v1/user/email/verify"

        let params: [String: Any] = [
            "email": email
        ]

        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding(options: []),
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
        .response { response in
            switch response.response?.statusCode {
            case 200:
                print("email-true")
                self.email_available.send(true)
            case 400:
                print("email-false")
                self.email_available.send(false)
            default:
                self.email_available.send(false)
                print(response.response?.statusCode ?? 0)
            }
        }
    }
    
    //MARK: - 가입가능 확인.  ##### 아 그런데 이걸 뷰에서 체크하는게아니라 궂이 VM에서 체크할이유가 있을까 싶기도 하고... 흠...
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
        print("register() - called")
        let url = "https://chatty.kr/api/v1/user/register"

        let params: [String: Any] = [
            "username" : username,
            "profile_name" : profile_name,
            "email": email,
            "password": password,
            "password2": password2,
        ]

        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding(options: []),
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
        .responseDecodable(of: UserData.self){ response in
            print(response)
            switch response.result {
            case .success(let data) :
                print(data.username, " - ", data.access_token, " - ", data.refresh_token, " - ", KeyChain.read(key: "fcm_token") ?? "")
                KeyChain.create(key: "access_token", value: data.access_token)
                KeyChain.create(key: "refresh_token", value: data.refresh_token)
                KeyChain.create(key: "username", value: data.username)
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                self.apnsTokenRegister()
                self.registerSuccess = true
            case .failure(_) :
                if let data = response.data,
                   let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                    print("Error : \(errorModel)")
                    if errorModel.status_code == 400 {
//                        self.registerError.send()
                        print("RegisterVM - register() 400 Error ")
                    } else {
                        print("Error with no model")
//                        self.registerError.send()
                    }
                }
            }
        }
    }
    
    func apnsTokenRegister() {
        let url = "https://chatty.kr/api/v1/user/FCM/ios"
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json", "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        let params: [String: Any] = [
            "token" : KeyChain.read(key: "fcm_token") ?? ""
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding(options: []),
                   headers: headers)
        .response{ response in
            switch response.result {
            case .success(_) :
                print("FCM 등록 완료")
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    
}
