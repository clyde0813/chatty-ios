//
//  LoginVM.swift
//  Chatty
//
//  Created by Clyde on 2023/05/30.
//

import Alamofire
import Combine
import Foundation


class LoginVM : ObservableObject {
    
    var isLoginSuccess = PassthroughSubject<Bool, Never>()
    
    @Published var username : String = ""
    
    @Published var password : String = ""
    
    func login(){
        print("login() - called")
        let url = "https://chatty.kr/api/v1/user/login"
        
        let params: [String: Any] = [
            "username" : username,
            "password": password
        ]
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding(options: []),
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
        .responseDecodable(of: UserData.self){ response in
            switch response.result {
            case .success(let data) :
                print(data.username, " - ", data.access_token, " - ", data.refresh_token, " - ", KeyChain.read(key: "fcm_token") ?? "")
                KeyChain.create(key: "access_token", value: data.access_token)
                KeyChain.create(key: "refresh_token", value: data.refresh_token)
                KeyChain.create(key: "username", value: data.username)
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                self.apnsTokenRegister()
                self.isLoginSuccess.send(true)
            case .failure(_) :
                if let data = response.data,
                   let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                    print("LoginVM - login() Error : \(errorModel)")
                    if errorModel.status_code == 401 {
                        self.isLoginSuccess.send(false)
                        print("LoginVM - login() ErrorCode 401")
                    } else {
                        self.isLoginSuccess.send(false)
                        print("LoginVM - login() Error No model")
                        
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
