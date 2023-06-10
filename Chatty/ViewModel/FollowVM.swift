import Alamofire
import Combine
import Foundation

class FollowVM : ObservableObject{
    @Published var followModel : FollowModel? = nil
    
    var isEmptyList = PassthroughSubject<(),Never>()
    
    func followGet(username: String, page : Int, tab:String){
        let url = "https://chatty.kr/api/v1/user/profile/\(username)/\(tab)"
        
        var headers : HTTPHeaders = []
        
//        let params: Parameters = [
//            "page": page
//        ]
        
        headers = ["Content-Type":"application/json", "Accept":"application/json"]
        
        AF.request(url,
                   method: .get,
//                   parameters: params,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .responseDecodable(of: FollowModel.self){ response in
            switch response.result {
            case .success(let data):
                print("Follow get : Success")
                print(data)
                self.followModel = data
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
