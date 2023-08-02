import Foundation
import Alamofire
import Combine

class ChattyService {
    
    static let share = ChattyService()
    
    //timeline에 있는 카드모델
    @Published var chattyModel : QuestionModel? = nil
    
    //profileView에 있는 카드모델
    @Published var questionModel : QuestionModel? = nil
    
    //위와같이 같은타입의 데이터를 나눈이유는
    //내 기술력이 부족해서 화면이사라질때 구독을 끊는방법을 모르겠음
    //하......나도 답답한데 모르겠ㅇ므..
    
    
    //좋아요
    func likedChatty(question_id : Int, completion: @escaping(Bool) -> ()) {

        let url = "https://chatty.kr/api/v1/chatty/like"

        var headers : HTTPHeaders = []

        headers = ["Content-Type":"application/json", "Accept":"application/json", "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]

        let params: Parameters = [
            "question_id" : question_id
        ]

        NetworkManager.shared.RequestServer(url: url, method: .post, headers: headers, params: params,encoding: JSONEncoding.default) { result in
            switch result{
            case .success(_):
                completion(true)
            case .failure(let errorModel):
                switch errorModel.status_code{
                case 400:
                    print("MyQuestionVM - onClickLike() : Fail \(errorModel)")
                case 500:
                    print("MyQuestionVM - onClickLike() : Fail \(errorModel)")
                case 401:
                    print("No Token")
                default:
                    print("MyQuestionVM - onClickLike() : Fail \(errorModel)")
                }
                completion(false)
            }
        }
    }
    
    //질문하기
    func questionPost(username: String, content: String, anonymous: Bool, completion: @escaping(Bool)->()) {
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
                completion(true)
            case .failure(let error):
                completion(false)
                print("error : \(error.errorDescription!)")
            }
        }
    }
    
    //질문삭제
    func questionDelete(question_id: Int, completion: @escaping (Bool)->() ) {
        let url = "https://chatty.kr/api/v1/chatty"
        var headers : HTTPHeaders = []
        headers = ["Content-Type":"application/json", "Accept":"application/json", "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
        let params: Parameters = [
            "question_id" : question_id
        ]
        NetworkManager.shared.RequestServer(url: url, method: .delete, headers: headers,params: params,encoding: JSONEncoding(options: [])){ result in
            switch result{
            
            case .success(_):
                self.chattyModel?.results.removeAll(where: {$0.pk == question_id})
                self.questionModel?.results.removeAll(where: {$0.pk == question_id})
                completion(true)
                
            case .failure(let errorModel):
                print(" questionDelete() : Fail \(errorModel)")
                switch errorModel.status_code{
                case 400:
                    print("1")
                case 500:
                    print("1")
                case 401:
                    TokenVM().refreshToken {
                        if $0{
                            print("token 갱신")
                        }
                    }
                default:
                    print("MyQuestionVM - timelineGet() : Fail \(errorModel)")
                }
                completion(false)
            }
        }
    }
    
    //질문 신고
    func questionReport(question_id: Int, completion: @escaping(Bool)->()) {
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
                print("Success")
                completion(true)
            case .failure(let error):
                print("error : \(error.errorDescription!)")
                completion(false)
            }
        }
    }
    
    //답변거절
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
            case .failure(let error):
                print("error : \(error.errorDescription!)")
            }
        }
    }
    
    func answerPost(question_id: Int, content: String, completion: @escaping (Bool)->()) {
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
                completion(true)
            case 401:
                if let data = response.data,
                   let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                    if errorModel.status_code == 401 {
                        TokenVM.share.refreshToken { result in
                            print("token refresh Success")
                        }
                    }
                }
                completion(false)
            default:
                print(response.response?.statusCode ?? 0)
                completion(false)
            }
        }
    }
    
    func getTimeLine(page:Int){
        let url : String = "https://chatty.kr/api/v1/chatty/timeline"

        var headers : HTTPHeaders = []
        
        guard let accessToken = KeyChain.read(key: "access_token") else { return }
        
        headers = ["Content-Type":"application/json", "Accept":"application/json", "Authorization": "Bearer " + accessToken]

        let params: Parameters = [
            "page": page as Any
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
                    TokenVM.share.refreshToken{ success in
                        if success {
                            self?.getTimeLine(page: page)
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
        
        guard let accessToken = KeyChain.read(key: "access_token") else { return }
        
        headers = ["Content-Type":"application/json", "Accept":"application/json","Authorization": "Bearer \(accessToken)"]
        
        let params: Parameters = [
            "page": page
        ]
        
        NetworkManager.shared.RequestServer(url: url, method: .get, headers: headers, params: params , encoding: URLEncoding.default) { [weak self] result in
            switch result {
            case .success(let data):
                print("MyQuestionVM - GetMyQuestion() : Success")
                self?.handleQuestionResponse2(data)
            case .failure(let errorModel):
                switch errorModel.status_code{
                case 400:
                    print("MyQuestionVM - GetMyQuestion() : Fail \(errorModel)")
                case 500:
                    print("MyQuestionVM - GetMyQuestion() : Fail \(errorModel)")
                case 401:
                    TokenVM.share.refreshToken { result in
                        if result {
                            print("refreshToken reset!")
                        }
                    }
                default:
                    print("MyQuestionVM - GetMyQuestion() : Fail \(errorModel)")
                }
            }
        }
    }
    
    
    
    func handleQuestionResponse(_ data: Data?) {
        guard let data = data ,let myData = try? JSONDecoder().decode(QuestionModel.self, from: data) else { return }
        
        if chattyModel == nil {
            chattyModel = myData
        }else {
            chattyModel?.results += myData.results
            chattyModel?.next = myData.next
            chattyModel?.previous = myData.previous
        }
    }
    
    func handleQuestionResponse2(_ data: Data?) {
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
