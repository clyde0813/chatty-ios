import Alamofire
import Combine
import Foundation

class FollowVM : ObservableObject{
    @Published var followModel : FollowModel? = nil
    
    var isGetFollowSuccess = PassthroughSubject<(),Never>()
    
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
                print("Follow get : Success")
                if self.followModel == nil {
                    self.followModel = data
                }else{
                    self.followModel?.results += data.results
                    self.followModel?.next = data.next
                    self.followModel?.previous = data.previous
                }
                self.isGetFollowSuccess.send()
            case .failure(_):
                print("Follow get : Failed")
                print(response)
                if let data = response.data,
                   let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                    print("Error Data : ", errorModel)
                }
            }
        }
    }
    
    func Follow(username : String) {
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
                print("실패")
            case 200:
                print("성공")
            default :
                print("error")
            }
        }
    }
//    func followingGet(username: String, page : Int){
//        let url = "https://chatty.kr/api/v1/user/profile/\(username)/followings"
//        let params: Parameters = [
//            "page" : page
//        ]
//        AF.request(url,
//                   method: .get,
//                   parameters: params,
//                   encoding: JSONEncoding.default,
//                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
//        .responseDecodable(of: FollowModel.self){ response in
//            switch response.result {
//            case .success(let data):
//                print("Profile get : Success")
//                self.followModel = data
//            case .failure(_):
//                print("Profile get : Failed")
//                print(response)
//                if let data = response.data,
//                   let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
//                    print("Error Data : ", errorModel)
//                }
//            }
//        }
//    }
}
