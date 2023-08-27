import Foundation
import Alamofire

class SettingVM : ObservableObject {
    
    @Published var toggleState : Bool
    
    init(toggleState : Bool){
        self.toggleState = toggleState
    }
    
    func rankingToggle(){
        let url = "https://chatty.kr/api/v1/user/ranking/toggle"
        
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json",
                   "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
        NetworkManager.shared.RequestServer(url: url, method: .post,headers: headers , encoding: JSONEncoding.default) { result in
            switch result {
            case .success(_):
                print("SettingVM : rankingToggle Success")
                AuthorizationService.share.currentUser?.rankState.toggle()
            case .failure(let errorModel):
                switch errorModel.status_code{
                case 400:
                    print("400 Error")
                default :
                    print("not Found Error")
                }
            }
        }
    }
}
