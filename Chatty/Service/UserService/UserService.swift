import Foundation
import Combine
import Alamofire

class UserService {
    
    static let share = UserService()
    
    @Published var user : ProfileModel? = nil
    
    @Published var userList : GenericListModel<ProfileModel>? = nil
    
    
    func profileGet(username: String){
        let url = "https://chatty.kr/api/v1/user/profile/\(username)"
        
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json",
                   "Authorization": "Bearer " + (KeyChain.read(key: "access_token") ?? "")]
        
        NetworkManager.shared.RequestServer(url: url, method: .get, headers: headers, encoding: URLEncoding.default){ result in
            switch result {
            case .success(let data):
                guard let data = data else {return}
                
                guard let data = try? JSONDecoder().decode(ProfileModel.self, from: data) else { return }
                
                self.user = data
                
            case .failure(let errorModel):
                switch errorModel.status_code{
                case 400:
                    print("ProfileVM - profileGet() : Fail \(errorModel)")
                case 500:
                    print("ProfileVM - profileGet() : Fail \(errorModel)")
                case 401:
                    TokenVM.share.refreshToken { result in
                        if result {
                            print("refreshToken Success!")
                        }
                    }
                default:
                    print("ProfileVM - profileGet() : Fail \(errorModel)")
                }
                
            }
        }
    }
    
    func Follow(username : String, completion: @escaping (Bool)->()) {
        let url = "https://chatty.kr/api/v1/user/follow"
        
        var headers : HTTPHeaders = []
        headers = ["Content-Type":"application/json", "Accept":"application/json", "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
        let parameters: [String: String] = [
            "username" : username
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .responseData{ response in
            switch response.response?.statusCode {
            case 201 :
                completion(false)
            case 200:
                completion(true)
            default :
                completion(false)
            }
        }
    }
    
    func followGet(username: String, page : Int, tab:String){
        
        let url = "https://chatty.kr/api/v1/user/profile/\(username)/\(tab)"
        
        var headers : HTTPHeaders = []
        
        let params: Parameters = [
            "page": page
        ]
        
        headers = ["Content-Type":"application/json", "Accept":"application/json",
                   "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
        AF.request(url,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: headers)
        .responseDecodable(of: GenericListModel<ProfileModel>.self){ response in
            switch response.result {
            case .success(let userlist):
                if self.userList == nil {
                    self.userList = userlist
                }else {
                    self.userList?.results += userlist.results
                    self.userList?.next = userlist.next
                    self.userList?.previous = userlist.previous
                }
                
            case .failure(_):
                print("FollowVM - FollowGet() : Fail")
                if let data = response.data,
                   let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                    print("Error Data : ", errorModel)
                }
            }
        }
    }
    
    func DeleteFollower(username : String, completion: @escaping (Bool)->()) {
        let url = "https://chatty.kr/api/v1/user/follow"
        
        var headers : HTTPHeaders = []
        headers = ["Content-Type":"application/json", "Accept":"application/json","Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
        let parameters: [String: String] = [
            "username" : username
        ]
        
        AF.request(url,
                   method: .delete,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .response{ response in
            switch response.response?.statusCode {
            case 201 :
                completion(false)
            case 200:
                print("FollowVM - DeleteFollower() : Success")
                self.userList?.results.removeAll{ $0.username == username }
                completion(true)
            default :
                completion(false)
                print(response.response?.statusCode ?? 0)
            }
        }
    }
    
    func followPost(username : String, completion: @escaping (Bool)-> ()) {
        let url = "https://chatty.kr/api/v1/user/follow"

        var headers : HTTPHeaders = []
        headers = ["Content-Type":"application/json", "Accept":"application/json","Authorization": "Bearer " + KeyChain.read(key: "access_token")!]

        let parameters: [String: String] = [
            "username" : username
        ]

        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .response{ response in
            switch response.response?.statusCode {
            case 201 :
                completion(false)
            case 200:
                print("Service - FollowPost() : Success")
                let index = self.userList?.results.firstIndex(where: {
                    $0.username == username
                })
                self.userList?.results[index!].followState.toggle()
                completion(true)
            default :
                print(response.response?.statusCode ?? 0)
                completion(false)
            }
        }
    }
    
    func userBlock(username : String, completion:@escaping(Bool)->()){
        let url = "https://chatty.kr/api/v1/user/block"
        
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json",
                   "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
        let parameters: [String: String] = [
            "username" : username
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .responseData { response in
            switch response.result {
            case .success(_):
                self.user?.blockState = true
                completion(true)
            case .failure(_):
                if let data = response.data,
                   let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                    print("Error Data : ", errorModel)
                }
                completion(true)
            }
        }
    }
    
    func DeleteUserBlock(username : String, completion: @escaping (Bool)-> ()) {
        let url = "https://chatty.kr/api/v1/user/block"
        
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json",
                   "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
        let parameters: [String: String] = [
            "username" : username
        ]
        
        AF.request(url,
                   method: .delete,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .responseData { response in
            switch response.result {
            case .success(_):
                
                //프로필을 들어가서 해제했을경우를 대비해서
                self.user?.blockState.toggle()
                completion(true)
                
            case .failure(_):
                print("ProfileVM - DeleteUserBlock() : Failed")
                print(response)
                if let data = response.data,
                   let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                    print("Error Data : ", errorModel)
                }
                completion(false)
            }
        }
    }
    
    func handleQuestionResponse(_ data: Data?) {
        guard let data = data ,let myData = try? JSONDecoder().decode(GenericListModel<ProfileModel>.self, from: data) else { return }
        
        if userList == nil {
            userList = myData
        }else {
            userList?.results += myData.results
            userList?.next = myData.next
            userList?.previous = myData.previous
        }
    }
}
