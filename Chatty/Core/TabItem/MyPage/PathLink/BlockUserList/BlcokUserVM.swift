import Foundation
import Alamofire

class BlockUserVM : ObservableObject {
    
    @Published var blockUserList : GenericListModel<ProfileModel>? = nil
    
    //차단리스트는 여기서만쓰이니까 여기에서 호출하는거 여기서 요청보내게함.
    func blockedUserListGet(){
        let url = "https://chatty.kr/api/v1/user/block"
        
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json",
                   "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .responseDecodable(of: GenericListModel<ProfileModel>.self){ response in
            switch response.result {
            case .success(let blockUserList):
                print("BlockUserVM - blockedUserListGet() : Success")
                self.blockUserList = blockUserList
                
            case .failure(_):
                print("BlockUserVM - blockedUserListGet() : Failed")
                if let data = response.data,
                   let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                    print("Error Data : ", errorModel)
                }
            }
        }
    }
    
    func deleteUserBlock(username:String){
        UserService.share.DeleteUserBlock(username: username) { result in
            if result{
                let index = self.blockUserList?.results.firstIndex(where: {
                    $0.username == username
                })
                self.blockUserList?.results.remove(at: index!)
            }
        }
    }
    
}
