import Foundation
import Alamofire
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    
    func fetchGetQuestion(completion: @escaping (Result<GenericListModel<ResultDetail>, Error>) -> Void){
        let url : String = "가져올 url"
        
        var headers : HTTPHeaders = []
        
        headers = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer " + KeyChain.read(key: "access_token")!
        ]
        
        let params: Parameters = [
            "page": 1
        ]
        
        AF.request(url,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: headers
        )
        .validate()
        .responseDecodable(of : GenericListModel<ResultDetail>.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func timelineGet(page: Int, completion: @escaping (Result<QuestionModel, Error>) -> Void){
        
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
            case .success(let data) :
                completion(.success(data))
            case .failure(let error) :
                completion(.failure(error))
            }
        }
    }
    
    func questionGet(questionType: String, username: String, page: Int, completion: @escaping(Result<QuestionModel,Error>) -> Void){
        
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
                print(data)
                print(response.data)
                completion(.success(data))
            case .failure(let error):
                print(error)
                print(response.data)
                completion(.failure(error))
            }
            
        }
    }
    
    func profileGet(username : String, completion: @escaping (Result<ProfileModel, Error>) -> Void){
        let url = "https://chatty.kr/api/v1/user/profile/\(username)"
        
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json",
                   "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .responseDecodable(of: ProfileModel.self){ response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}

