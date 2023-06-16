//
//  QuestionVM.swift
//  Chatty
//
//  Created by Clyde on 2023/06/08.
//

import Foundation
import Alamofire
import Combine
import Foundation

class QuestionVM : ObservableObject {
    var subscription = Set<AnyCancellable>()
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
    
    func questionPost(username: String, content: String, anonymous: Bool) {
        let url = "https://chatty.kr/api/v1/chatty"
        var headers : HTTPHeaders = []
        
        //2023.06.16 -신현호 차후,헤더에 토큰추가
        headers = ["Content-Type":"application/json", "Accept":"application/json"]
        
        let params: Parameters = [
            "target_profile" : username,
            "content" : content
            //2023.06.16 -신현호 차후, 파라미터에 익명체크여부 추가
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
                print("Refuse 성공")
                self.refuseComplete.send()
                print("self.refuseComplete.send()")
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
    
    func timelineGet(page: Int){
        let url : String = "https://chatty.kr/api/v1/chatty/timeline"
        
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json", "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
        let params: Parameters = [
            "page": page
        ]
        
        AF.request(url,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: headers
        )
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
                                self.timelineGet(page: page)
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
