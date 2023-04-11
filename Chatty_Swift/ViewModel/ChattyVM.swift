//
//  UserVM.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/01/24.
//

import Foundation
import Alamofire
import Combine

class ChattyVM: ObservableObject {
    var subscription = Set<AnyCancellable>()
    
    @Published var loggedInUser: UserData? = nil
    
    @Published var profileModel : ProfileModel? = nil
    
    @Published var questionModel : QuestionModel? = nil
    
    @Published var tokenModel : TokenModel? = nil
    
    @Published var errorModel : ErrorModel? = nil
    
    var loginSuccess = PassthroughSubject<(), Never>()
    
    var logoutSuccess = PassthroughSubject<(), Never>()
    
    var refuseComplete = PassthroughSubject<(), Never>()
    
    func refreshToken() {
        print("refreshToken() - called")
        let url = "https://chatty.kr/api/v1/user/api/token/refresh/"
        
        let params: [String: Any] = [
            "refresh" : String(KeyChain.read(key: "refresh_token") ?? "")
        ]

        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding(options: []),
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
        .responseDecodable(of: TokenModel.self){ response in
            switch response.result {
            case .success(let data) :
                self.tokenModel = data
                KeyChain.delete(key: "access_token")
                KeyChain.delete(key: "refresh_token")
                KeyChain.create(key: "access_token", value: String(self.tokenModel?.access ?? ""))
                KeyChain.create(key: "refresh_token", value: String(self.tokenModel?.refresh ?? ""))
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    func login(username:String, password:String){
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
                print(data.username, " - ", data.access_token, " - ", data.refresh_token)
                KeyChain.create(key: "access_token", value: data.access_token)
                KeyChain.create(key: "refresh_token", value: data.refresh_token)
                KeyChain.create(key: "username", value: data.username)
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                self.loginSuccess.send()
            case .failure(let error) :
                print("error : ", error)
            }
        }
    }
    
    func logout(){
        KeyChain.delete(key: "username")
        KeyChain.delete(key: "access_token")
        KeyChain.delete(key: "refresh_token")
        self.logoutSuccess.send()
    }
    
    func fetchUserInfo(username: String){
        let url = "https://chatty.kr/api/v1/user/profile/\(username)"
        
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
        .responseDecodable(of: ProfileModel.self){ response in
            switch response.result {
            case .success(let data):
                self.profileModel = data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func questionGet(questionType: String, username: String, page: Int){
        var urlPath : String = ""
        var headers : HTTPHeaders = []
        
        print(questionType, " - called")
        
        if questionType == "responsed" {
            urlPath = "user/\(username)"
            headers = ["Content-Type":"application/json", "Accept":"application/json"]
        }
        
        if questionType == "arrived" {
            urlPath = "arrived"
            headers = ["Content-Type":"application/json", "Accept":"application/json", "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        }
        
        if questionType == "refused" {
            urlPath = "refused"
            headers = ["Content-Type":"application/json", "Accept":"application/json", "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        }
        
        let url = "https://chatty.kr/api/v1/chatty/" + urlPath
        
        let params: Parameters = [
            "page": page
        ]
        
        AF.request(url,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: headers)
        .responseDecodable(of: QuestionModel.self){ response in
            switch response.result {
            case .success(let data):
                self.questionModel = data
            case .failure(_):
                if let data = response.data,
                   let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                    print("Error : \(errorModel)")
                    if errorModel.status_code == 401 {
                        self.refreshToken()
                        self.questionGet(questionType: questionType, username: username, page: page)
                    }
                } else {
                    print("Error with no model")
                }
            }
        }
    }
    
    func questionPost(username: String, content: String) {
        let url = "https://chatty.kr/api/v1/chatty"
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json"]
        
        let params: Parameters = [
            "target_profile" : username,
            "content" : content
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding(options: []),
                   headers: headers)
        .responseString { (response) in
            switch response.result {
            case .success:
                print("POST 성공")
            case .failure(let error):
                print("error : \(error.errorDescription!)")
            }
        }
    }
    
    func questionReject(question_id: Int) {
        let url = "https://chatty.kr/api/v1/chatty/refused"
        var headers : HTTPHeaders = []
        headers = ["Content-Type":"application/json", "Accept":"application/json", "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
        let params: Parameters = [
            "question_id" : question_id
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding(options: []),
                   headers: headers)
        .responseString { (response) in
            switch response.result {
            case .success:
                print("POST 성공")
                self.refuseComplete.send()
            case .failure(let error):
                print("error : \(error.errorDescription!)")
            }
        }
    }
}
