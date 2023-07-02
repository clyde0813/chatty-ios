import Alamofire
import Combine
import Foundation

class FollowVM : ObservableObject{
    @Published var followModel : FollowModel? = nil
    
    var isGetFollowSuccess = PassthroughSubject<(),Never>()
    
    var DeleteFollowerSuccess = PassthroughSubject<(),Never>()
    
    var toggleToSearchView = PassthroughSubject<(),Never>()
    
    
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
        .responseDecodable(of: FollowModel.self){ response in
            switch response.result {
            case .success(let data):
                print("FollowVM - FollowGet() : Success")
                if self.followModel == nil {
                    self.followModel = data
                }else{
                    print("팔로우 팔로잉 데이터는 \n \(data.results)")
                    self.followModel?.results += data.results
                    self.followModel?.next = data.next
                    self.followModel?.previous = data.previous
                }
                self.isGetFollowSuccess.send()
            case .failure(_):
                print("FollowVM - FollowGet() : Fail")
                if let data = response.data,
                   let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                    print("Error Data : ", errorModel)
                }
            }
        }
    }
    
    func followPost(username : String) {
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
                print("FollowVM - followPost() 201")
            case 200:
                print("FollowVM - FollowPost() : Success")
                let index = self.followModel?.results.firstIndex(where: {
                    $0.username == username
                })
                self.followModel?.results[index!].followState.toggle()
                self.toggleToSearchView.send()
            default :
                print(response.response?.statusCode ?? 0)
            }
        }
    }
    
    func DeleteFollower(username : String) {
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
                print("FollowVM - DeleteFollower() : 201")
            case 200:
                print("FollowVM - DeleteFollower() : Success")
                self.followModel?.results.removeAll{ $0.username == username }
                self.DeleteFollowerSuccess.send()
            default :
                print(response.response?.statusCode ?? 0)
            }
        }
    }

}
