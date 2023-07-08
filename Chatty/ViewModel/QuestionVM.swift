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
    
    var publisher = PassthroughSubject<String, Never>()
    
    
    //MARK: - Getinit()
//    func questionGet(questionType: String, username: String, page: Int){
//        NetworkManager.shared.questionGet(questionType: questionType, username: username, page: page) { [weak self] result in
//            switch result {
//            case .success(let data):
//                self?.handleQuestionResponse(data)
//            case .failure(let error):
//                print("MyQuestionVM - questionGet(): Fail")
//                switch errorModel.status_code{
//                case 400:
//                    print("MyQuestionVM - GetMyQuestion() : Fail \(errorModel)")
//                case 500:
//                    print("MyQuestionVM - GetMyQuestion() : Fail \(errorModel)")
//                case 401:
//                    self?.token.refreshToken() { success in
//                        if success {
//                            self?.timelineGet(page: 1)
//                        } else {
//                            print("Token Refresh Fail!")
//                        }
//                    }
//                default:
//                    print("MyQuestionVM - GetMyQuestion() : Fail \(errorModel)")
//                }
////                self?.handleQuestionError(error)
//            }
//        }
//    }
    
//    func GetTimeline(page :Int){
//        NetworkManager.shared.timelineGet(page: page) { [weak self] result in
//            switch result {
//            case .success(let data) :
//                print("MyQuestionVM - fetchGetQuestion(): Success")
//                self?.handleQuestionResponse(data)
//            case .failure(let error):
//                print("MyQuestionVM - fetchGetQuestion(): Fail")
//                self?.handleQuestionError(error)
//            }
//        }
//    }
    
    func timelineGet(page: Int){
        let url : String = "https://chatty.kr/api/v1/chatty/timeline"
        
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json", "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
        let params: Parameters = [
            "page": page
        ]
        
        NetworkManager.shared.RequestServer(url: url, method: .get, headers: headers, params: params,encoding: URLEncoding.default) { [weak self] result in
            switch result{
            case .success(let data):
                print("MyQuestionVM - timelineGet() : Success")
                self?.handleQuestionResponse(data)
                
            case .failure(let errorModel):
                switch errorModel.status_code{
                case 400:
                    print("MyQuestionVM - timelineGet() : Fail \(errorModel)")
                case 500:
                    print("MyQuestionVM - timelineGet() : Fail \(errorModel)")
                case 401:
                    self?.token.refreshToken() { success in
                        if success {
                            self?.timelineGet(page: 1)
                        } else {
                            print("Token Refresh Fail!")
                        }
                    }
                default:
                    print("MyQuestionVM - timelineGet() : Fail \(errorModel)")
                }
            }
        }
    }
    
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
        
        NetworkManager.shared.RequestServer(url: url, method: .get, headers: headers, params: params , encoding: URLEncoding.default) { [weak self] result in
            switch result {
            case .success(let data):
                print("MyQuestionVM - GetMyQuestion() : Success")
                self?.handleQuestionResponse(data)
            case .failure(let errorModel):
                switch errorModel.status_code{
                case 400:
                    print("MyQuestionVM - GetMyQuestion() : Fail \(errorModel)")
                case 500:
                    print("MyQuestionVM - GetMyQuestion() : Fail \(errorModel)")
                case 401:
                    self?.token.refreshToken() { success in
                        if success {
                            self?.questionGet(questionType: questionType, username: username, page: page)
                        } else {
                            print("Token Refresh Fail!")
                        }
                    }
                default:
                    print("MyQuestionVM - GetMyQuestion() : Fail \(errorModel)")
                }
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
    
    func onClickLike(question_id : Int){

        let url = "https://chatty.kr/api/v1/chatty/like"

        var headers : HTTPHeaders = []

        headers = ["Content-Type":"application/json", "Accept":"application/json", "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]

        let params: Parameters = [
            "question_id" : question_id
        ]

        NetworkManager.shared.RequestServer(url: url, method: .post, headers: headers, params: params,encoding: JSONEncoding.default) { [weak self] result in
            switch result{
            case .success(_):
                let index = self?.questionModel?.results.firstIndex(where: {
                    $0.pk == question_id
                })
                self?.questionModel?.results[index!].likeStatus.toggle()
                print("togleAction Success")
            case .failure(let errorModel):
                switch errorModel.status_code{
                case 400:
                    print("MyQuestionVM - onClickLike() : Fail \(errorModel)")
                case 500:
                    print("MyQuestionVM - onClickLike() : Fail \(errorModel)")
                case 401:
                    self?.token.refreshToken() { success in
                        if success {
                            self?.onClickLike(question_id: question_id)
                        } else {
                            print("Token Refresh Fail!")
                        }
                    }
                default:
                    print("MyQuestionVM - onClickLike() : Fail \(errorModel)")
                }
            }
        }
    }
}


extension QuestionVM {
    
    func handleQuestionResponse(_ data: Data?) {
        guard let data = data ,let myData = try? JSONDecoder().decode(QuestionModel.self, from: data) else { return }
        
        if questionModel == nil {
            questionModel = myData
        }else {
            questionModel?.results += myData.results
            questionModel?.next = myData.next
            questionModel?.previous = myData.previous
        }
    }


}
