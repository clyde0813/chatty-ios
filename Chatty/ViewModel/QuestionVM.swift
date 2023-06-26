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
        
        if questionType == "responsed" {
            urlPath = "user/\(username)"
        }
        else if questionType == "arrived" {
            urlPath = "arrived"
        }
        else if questionType == "refused" {
            urlPath = "refuse"
        }
        
        let url = "https://chatty.kr/api/v1/chatty/" + urlPath
        
        headers = ["Content-Type":"application/json", "Accept":"application/json","Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
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
                
                guard let stateCode = response.response?.statusCode else { return }
                
                if stateCode == 200 {
                    print("QuestionVM - questionGet() - 200")
                    if self.questionModel == nil {
                        self.questionModel = data
                    }else{
                        self.questionModel?.results += data.results
                        self.questionModel?.next = data.next
                        self.questionModel?.previous = data.previous
                    }
                }
                else if stateCode == 400 {
                    print("QuestionVM - questionGet() - 400")
                }

                if self.questionModel?.results.isEmpty == true{
                    print("QuestionVM- guestionGet() : 질문 데이터가 비어있어")
                    self.isSuccessGetQuestion.send(false)
                }else{
                    print("QuestionVM- guestionGet() : 데이터가 들어있어")
                    print(self.questionModel?.results)
                    self.isSuccessGetQuestion.send(true)
                }
                
            case .failure(_):
                print("실패! 원인은! \n\(response)")
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
    
    //질문하기
    func questionPost(username: String, content: String, anonymous: Bool) {
        let url = "https://chatty.kr/api/v1/chatty"
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json","Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
        let params: Parameters = [
            "username" : username,
            "content" : content,
            "anonymous_status" : anonymous
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding(options: []),
                   headers: headers)
        .responseString { (response) in
            switch response.result {
            case .success:
                print("질문은 성공이 맞는데?")
                self.questionPostSuccess.send()
            case .failure(let error):
                print("error : \(error.errorDescription!)")
            }
        }
    }
    
    //질문신고
    func questionReport(question_id: Int) {
        let url = "https://chatty.kr/api/v1/chatty/report"
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
                print("Report 성공")
                self.reportSuccess.send()
            case .failure(let error):
                print("error : \(error.errorDescription!)")
            }
        }
    }
    
    //질문삭제
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
                print("question_id는 \(question_id)")
                
                self.questionModel?.results.removeAll(where: { $0.pk == question_id })
                
                self.deleteSuccess.send()
            case .failure(let error):
                print("error : \(error.errorDescription!)")
            }
        }
    }
    
    //질문거절
    func questionRefuse(question_id: Int) {
        let url = "https://chatty.kr/api/v1/chatty/refuse"
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
                self.questionModel?.results.removeAll{
                    $0.pk == question_id
                }
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
                self.questionModel?.results.removeAll{
                    $0.pk == question_id
                }
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
