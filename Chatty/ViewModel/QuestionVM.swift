import Foundation
import Alamofire
import Combine
import Foundation

class QuestionVM : ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    //새로추가
    @Published var questionModel : QuestionModel? = nil
    
    @Published var isLoading = false
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
    
    
    //MARK: - Getinit()
    func questionGet(questionType: String, username: String, page: Int){
        NetworkManager.shared.questionGet(questionType: questionType, username: username, page: page) { [weak self] result in
            switch result {
            case .success(let data):
                print("MyQuestionVM - questionGet(): Success")
                self?.handleQuestionResponse(data)
            case .failure(let error):
                print("MyQuestionVM - questionGet(): Fail")
                self?.handleQuestionError(error)
            }
        }
    }
    
    func GetTimeline(page :Int){
        NetworkManager.shared.timelineGet(page: page) { [weak self] result in
            switch result {
            case .success(let data) :
                print("MyQuestionVM - fetchGetQuestion(): Success")
                self?.handleQuestionResponse(data)
            case .failure(let error):
                print("MyQuestionVM - fetchGetQuestion(): Fail")
                self?.handleQuestionError(error)
            }
        }
    }
    
    
    //MARK: - 질문, 답장, 삭제, 거절, 신고
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
                self.questionPostSuccess.send()
            case .failure(let error):
                print("error : \(error.errorDescription!)")
            }
        }
    }
    
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
                print("question_id는 \(question_id)")
                
                self.questionModel?.results.removeAll(where: { $0.pk == question_id })
                
                self.deleteSuccess.send()
            case .failure(let error):
                print("error : \(error.errorDescription!)")
            }
        }
    }
    
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
}


extension QuestionVM {
    
    func handleQuestionResponse(_ data: QuestionModel) {
        if questionModel == nil {
            questionModel = data
        }else {
            questionModel?.results += data.results
            questionModel?.next = data.next
            questionModel?.previous = data.previous
        }
    }
    
    func handleQuestionError(_ error: Error) {
        
        if let afError = error as? AFError, let statusCode = afError.responseCode {
            handleStatusCodeError(statusCode)
        }else{
            handleNetworkError()
        }
    }
    
    func handleStatusCodeError(_ statusCode : Int, retryAction: (() -> Void)? = nil){
        switch statusCode {
        case 400 :
            print("400")
        case 401 :
            print("401")
        case 500 :
            print("500")
        default:
            print("!!")
        }
    }
    
    func handleNetworkError(){
        print("네트워크에러!")
    }
}
