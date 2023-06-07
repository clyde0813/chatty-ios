//
//  ProfileVM.swift
//  Chatty
//
//  Created by Clyde on 2023/06/04.
//

import Foundation
import Alamofire
import Combine
import Foundation

class ProfileVM : ObservableObject {    
    @Published var profileModel : ProfileModel? = nil
    
    //새로추가
    @Published var questionModel : QuestionModel? = nil
    let token = TokenVM()
    
    //새로추가
    var questionPostSuccess = PassthroughSubject<(), Never>()
    //새로추가
    var reportSuccess = PassthroughSubject<(), Never>()
    //새로추가
    var deleteSuccess = PassthroughSubject<(), Never>()
    //새로추가
    var refuseComplete = PassthroughSubject<(), Never>()
    //새로추가
    var answerComplete = PassthroughSubject<(), Never>()
    //새로추가
    var isSuccessGetQuestion = PassthroughSubject<Bool, Never>()
    
    var profileEditSuccess = PassthroughSubject<(), Never>()
    
    func profileGet(username: String){
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
                print(response)
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
            "username" : username,
            "profile_name": profile_name,
            "profile_message": profile_message
        ]
        
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
                if let profile_image_data = profile_image?.jpegData(compressionQuality: 1) {
                    multipartFormData.append(profile_image_data, withName: "profile_image", fileName: "\(username).jpg", mimeType: "image/jpg")
                }
                if let background_image_data = background_image?.jpegData(compressionQuality: 1) {
                    multipartFormData.append(background_image_data, withName: "background_image", fileName: "\(username).jpg", mimeType: "image/jpg")
                }
            },
            to: url,
            method: .put,
            headers: headers
        )
        .response { response in
            switch response.response?.statusCode {
            case 200:
                if username != "" {
                    KeyChain.delete(key: "username")
                    KeyChain.create(key: "username", value: username)
                }
                self.profileEditSuccess.send()
            case 401:
                TokenVM().refreshToken() { success in
                    if success {
                        self.profileEdit(username: username, profile_name: profile_name, profile_message: profile_message, profile_image: profile_image, background_image: background_image)
                    } else {
                        print("Error with no model")
                    }
                }
            default:
                print("Profile Edit Failed")
            }
        }
    }
    
    func SumOfQuestion() -> Int{
        return (profileModel?.questionCount.answered ?? 0) + (profileModel?.questionCount.unanswered ?? 0) + (profileModel?.questionCount.rejected ?? 0)
    }
    
    
    //MARK: - 카드뷰에서 쓰일 함수들
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
                print("questionGet() - success")
                if self.questionModel == nil {
                    self.questionModel = data
                }else{
                    self.questionModel?.results += data.results
                    self.questionModel?.next = data.next
                    self.questionModel?.previous = data.previous
                }
                if data.results.isEmpty{
                    print("데이터가 비어있어")
                    self.isSuccessGetQuestion.send(false)
                }else{
                    print("데이터가 들어있어")
                    self.isSuccessGetQuestion.send(true)
                }
                
            case .failure(_):
                if let data = response.data,
                   let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                    if errorModel.status_code == 401 {
                        self.token.refreshToken() { success in
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
    
    func questionReport(question_id: Int) {
        let url = "https://chatty.kr/api/v1/chatty"
        var headers : HTTPHeaders = []
        headers = ["Content-Type":"application/json", "Accept":"application/json", "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
        let params: Parameters = [
            "question_id" : question_id
        ]
        
        AF.request(url,
                   method: .delete,
                   parameters: params,
                   encoding: JSONEncoding(options: []),
                   headers: headers)
        .responseData { response in
            switch response.result {
            case .success:
                print("Report & Delete 성공")
                self.reportSuccess.send()
            case .failure(let error):
                print("error : \(error.errorDescription!)")
            }
        }
    }
    
    func questionDelete(question_id: Int) {
        let url = "https://chatty.kr/api/v1/chatty"
        var headers : HTTPHeaders = []
        headers = ["Content-Type":"application/json", "Accept":"application/json", "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
        let params: Parameters = [
            "question_id" : question_id
        ]
        
        AF.request(url,
                   method: .delete,
                   parameters: params,
                   encoding: JSONEncoding(options: []),
                   headers: headers)
        .responseData { response in
            switch response.result {
            case .success:
                print("DELETE 성공")
                self.deleteSuccess.send()
            case .failure(let error):
                print("error : \(error.errorDescription!)")
            }
        }
    }
    
    func questionRefuse(question_id: Int) {
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
                ChattyVM().refuseComplete.send()
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
                        self.token.refreshToken() { success in
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
    
    
    func timelineGet(){
        let url : String = "https://chatty.kr/api/v1/chatty/timeline"
        
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json", "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        print(KeyChain.read(key: "access_token")!)
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: headers)
        .responseDecodable(of: QuestionModel.self){ response in
            switch response.result {
            case .success(let data):
                print("TimeLine get : Success")
                print("타임라인의 데이터는! \(data)")
                if self.questionModel == nil {
                    self.questionModel = data
                }else{
                    self.questionModel?.results += data.results
                    self.questionModel?.next = data.next
                    self.questionModel?.previous = data.previous
                }
                if data.results.isEmpty{
                    print("timeline이  비어있어")
                    self.isSuccessGetQuestion.send(false)
                }else{
                    print("timeline이 들어있어")
                    self.isSuccessGetQuestion.send(true)
                }
            case .failure(_):
                print("Profile get : Failed")
                if let data = response.data,
                   let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                    if errorModel.status_code == 401 {
                        self.token.refreshToken() { success in
                            if success {
                                self.timelineGet()
                            } else {
                                print("Token Refresh Failed")
                            }
                        }
                    }
                }
            }
        }
    }
    
}
