import Alamofire
import Combine
import Foundation

class QuestionDetailVM : ObservableObject {
    
    @Published var followingModel : FollowModel? = nil
    
    var isGetSuccessFollowings = PassthroughSubject<(),Never>()
    
    
    
    
    func followGet(username: String, page : Int){
        
        let url = "https://chatty.kr/api/v1/user/profile/\(username)/followings"
        
        var headers : HTTPHeaders = []
        
        let params: Parameters = [
            "page": page
        ]
        
        headers = ["Content-Type":"application/json", "Accept":"application/json",
                   "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        print(KeyChain.read(key: "access_token")!)
        AF.request(url,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: headers)
        .responseDecodable(of: FollowModel.self){ response in
            switch response.result {
            case .success(let data):
                print("Follow get : Success")
                if self.followingModel == nil {
                    self.followingModel = data
                }else{
                    self.followingModel?.results += data.results
                    self.followingModel?.next = data.next
                    self.followingModel?.previous = data.previous
                }
                self.isGetSuccessFollowings.send()
            case .failure(_):
                print("실패임?")
                print(response)
                if let data = response.data,
                   let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                    print("Error Data : ", errorModel)
                }
            }
        }
    }
}
