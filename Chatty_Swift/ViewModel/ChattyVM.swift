//
//  UserVM.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/01/24.
//

import Foundation
import Alamofire
import Combine
import SwiftUI

class ChattyVM: ObservableObject {
    var subscription = Set<AnyCancellable>()
        
    @Published var loggedInUser: UserData? = nil
    
    @Published var profileModel : ProfileModel? = nil
    
    @Published var questionModel : QuestionModel? = nil
    
    @Published var tokenModel : TokenModel? = nil
    
    @Published var errorModel : ErrorModel? = nil
    
    @Published var rankingModel : RankingModel? = nil
    
    // 답변 등록
    @Published var answerEditorStatus : Bool = false
    @Published var answerEditorQuestionId : Int = 0
    
    //질문 옵션 변수
    @Published var questionOptionStatus : Bool = false
    
    @Published var username : String = ""
    
    @Published var profile_name : String = ""
    
    @Published var profile_image : String = ""
    
    @Published var background_image : String = ""
    
    @Published var questiondata : ResultDetail? = ResultDetail(pk: 0, content: "", createdDate: "", answerContent: "")

    //
    
    var profileEditPressed = PassthroughSubject<(), Never>()
    
    var profilePressed = PassthroughSubject<(), Never>()
    
    var shareViewPass = PassthroughSubject<(), Never>()
        
    var loginSuccess = PassthroughSubject<(), Never>()
    
    var logoutSuccess = PassthroughSubject<(), Never>()
    
    var refuseComplete = PassthroughSubject<(), Never>()
        
    var answerComplete = PassthroughSubject<(), Never>()
    
    var usernameAvailable = PassthroughSubject<(), Never>()
    
    var usernameUnavailable = PassthroughSubject<(), Never>()
    
    var emailAvailable = PassthroughSubject<(), Never>()
    
    var emailUnavailable = PassthroughSubject<(), Never>()
    
    var loginError = PassthroughSubject<(), Never>()
    
    var registerSuccess = PassthroughSubject<(), Never>()
    
    var registerError = PassthroughSubject<(), Never>()
    
    var questionPostSuccess = PassthroughSubject<(), Never>()
    
    func apnsTokenInitialize(completion: @escaping (Bool) -> Void) {
        let url = "https://chatty.kr/api/v1/user/FCM/ios"
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json"]
        let params: [String: Any] = [
            "token" : KeyChain.read(key: "fcm_token") ?? ""
        ]
        
        AF.request(url,
                   method: .delete,
                   parameters: params,
                   encoding: JSONEncoding(options: []),
                   headers: headers)
        .response{ response in
            switch response.result {
            case .success(_) :
                print("FCM 토큰 초기화 완료")
            case .failure(let error) :
                print(error)
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
    
    func refreshToken(completion: @escaping (Bool) -> Void){
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
                completion(true)
            case .failure(_) :
                if let data = response.data,
                   let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                    print("Error : \(errorModel.status_code)")
                    if errorModel.status_code == 401 {
                        print("RefreshToken : 401")
                    } else {
                        print("RefreshToken : Error with no model")
                    }
                }
            }
        }
    }
    
    func register(username: String, profile_name: String, email:String, password: String, password2: String){
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
                self.registerSuccess.send()
            case .failure(_) :
                if let data = response.data,
                   let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                    print("Error : \(errorModel)")
                    if errorModel.status_code == 400 {
                        self.registerError.send()
                    } else {
                        print("Error with no model")
                        self.registerError.send()
                    }
                }
            }
        }
    }
    
    func verifyUsername(username: String){
        let url = "https://chatty.kr/api/v1/user/profile/\(username)"
        
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
        .response { response in
            switch response.response?.statusCode {
            case 200:
                self.usernameUnavailable.send()
            case 400:
                self.usernameAvailable.send()
            default:
                self.usernameUnavailable.send()
            }
        }
    }
    
    func verifyEmail(username: String, email: String){
        let url = "https://chatty.kr/api/v1/user/email/verify"
        
        let params: [String: Any] = [
            "username" : username,
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
                self.emailAvailable.send()
            case 400:
                self.emailUnavailable.send()
            default:
                print(response.response?.statusCode ?? 0)
            }
        }
    }
    
    func login(username:String, password:String){
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
                self.loginSuccess.send()
            case .failure(_) :
                if let data = response.data,
                   let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                    print("Error : \(errorModel)")
                    if errorModel.status_code == 401 {
                        self.loginError.send()
                    } else {
                        print("Error with no model")
                        self.loginError.send()
                    }
                }
            }
        }
    }
    
    func logout(){
        self.logoutSuccess.send()
        UserDefaults.standard.setValue(false, forKey: "isLoggedIn")
        self.apnsTokenInitialize() { success in
            KeyChain.delete(key: "username")
            KeyChain.delete(key: "access_token")
            KeyChain.delete(key: "refresh_token")
        }
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
                print("Profile get : Success")
                self.profileModel = data
            case .failure(_):
                print("Profile get : Failed")
                if let data = response.data,
                   let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                    print("Error Data : ", errorModel)
                }
            }
        }
    }
    
    func profileEdit(username: String, profile_name: String, profile_message: String, profile_image: UIImage?, background_image: UIImage?){
        let url = "https://chatty.kr/api/v1/user/profile"

        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json", "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
        let parameters: [String: Any] = [
            "profile_name": profile_name,
            "profile_message": profile_message
        ]
                
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
                if let image = profile_image?.pngData() {
                    multipartFormData.append(image, withName: "profile_image", fileName: "\(username).jpg", mimeType: "image/jpg")
                }
                if let image = background_image?.pngData() {
                    multipartFormData.append(image, withName: "background_image", fileName: "\(username).jpg", mimeType: "image/jpg")
                }
            },
            to: url,
            method: .put,
            headers: headers
        )
        .responseString { (response) in
            switch response.result {
            case .success:
                self.questionPostSuccess.send()
            case .failure(let error):
                print("error : \(error.errorDescription!)")
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
                    if errorModel.status_code == 401 {
                        self.refreshToken() { success in
                            if success {
                                self.questionGet(questionType: questionType, username: username, page: page)
                            } else {
                                print("Token Refresh Failed")
                            }
                        }
                    }
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
                self.questionPostSuccess.send()
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
        .responseData { response in
            switch response.result {
            case .success:
                print("POST 성공")
                self.refuseComplete.send()
            case .failure(let error):
                print("error : \(error.errorDescription!)")
            }
        }
    }
    
    func answerPost(question_id: Int, content: String) {
        let url = "https://chatty.kr/api/v1/chatty/answer"
        var headers : HTTPHeaders = []
        headers = ["Content-Type":"application/json", "Accept":"application/json", "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
        let params: Parameters = [
            "question_id" : question_id,
            "content" : content
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding(options: []),
                   headers: headers)
        .response { response in
            switch response.response?.statusCode {
            case 200:
                print("POST 성공")
                self.answerComplete.send()
            case 401:
                if let data = response.data,
                   let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                    print("Error : \(errorModel.status_code)")
                    if errorModel.status_code == 401 {
                        self.refreshToken() { success in
                            if success {
                                self.answerPost(question_id: question_id, content: content)
                            } else {
                                print("Error with no model")
                            }
                        }
                    }
                }
            default:
                print(response.response?.statusCode ?? 0)
            }
        }
    }
    
    func rankingGet() {
        let url = "https://chatty.kr/api/v1/user/ranking"
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json"]
        
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: headers)
        .responseDecodable(of: RankingModel.self){ response in
            switch response.result {
            case .success(let data):
                self.rankingModel = data
            case .failure(_):
                print("Ranking Get Error")
            }
        }
    }
}

