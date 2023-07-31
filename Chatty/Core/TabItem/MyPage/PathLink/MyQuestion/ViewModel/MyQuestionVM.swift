import Foundation
import Combine
import Alamofire


class MyQuestionVM : ObservableObject {
    
    @Published var myQuestionModel : GenericListModel<ResultDetail>? = nil

    func GetMyQuestion(page : Int){
        let url : String = "https://chatty.kr/api/v1/chatty/sent"
        
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json", "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
        let params: Parameters = [
            "page": page
        ]
        
        NetworkManager.shared.RequestServer(url: url, method: .get, headers: headers, params: params,encoding: URLEncoding.default) { [weak self] result in
            switch result {
            case .success(let data):
                
                guard let data = data else {return}
                let myData = try? JSONDecoder().decode(GenericListModel<ResultDetail>.self, from: data)
                if self?.myQuestionModel == nil {
                    self?.myQuestionModel = myData
                }
                else{
                    self?.myQuestionModel?.results += myData?.results ?? []
                    self?.myQuestionModel?.next = myData?.next
                    self?.myQuestionModel?.previous = myData?.previous
                }
                
            case .failure(let errorModel):
                
                switch errorModel.status_code{
                case 400:
                    print("MyQuestionVM - GetMyQuestion() : Fail \(errorModel)")
                case 500:
                    print("MyQuestionVM - GetMyQuestion() : Fail \(errorModel)")
                case 401:
                    TokenVM.share.refreshToken { result in
                        if result {
                            print("Token refresh Complete")
                        }
                    }
                default:
                    print("MyQuestionVM - GetMyQuestion() : Fail \(errorModel)")
                }
            }
        }
        
    }

    
}
