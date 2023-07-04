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
        
        let url = "https://chatty.kr/api/v1/user/login"
        
        let params: [String: Any] = [
            "username" : username,
            "password": password
        ]
        
        var header : HTTPHeaders
        header = ["Content-Type":"application/json", "Accept":"application/json"]
        NetworkManager.shared.RequestServer(url: url, method: .post, headers: header,params: params, encoding: JSONEncoding(options: [])) { [weak self] result in
            switch result {
            case .success(let data):
                guard let data = data, let data = try? JSONDecoder().decode(UserData.self, from: data) else { return }
                KeyChain.create(key: "access_token", value: data.access_token)
                KeyChain.create(key: "refresh_token", value: data.refresh_token)
                KeyChain.create(key: "username", value: data.username)
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                self?.apnsTokenRegister()
                self?.isLoginSuccess.send(true)
            case .failure(let errorModel):
                print("LoginVM - login() : Fail \(errorModel)")
                switch errorModel.status_code{
                case 401:
                    self?.isLoginSuccess.send(false)
                default:
                    print("LoginVM - login() : Fail \(errorModel)")
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
