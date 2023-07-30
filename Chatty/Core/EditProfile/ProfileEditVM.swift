import Foundation
import Combine
import SwiftUI
import Alamofire

class ProfileEditVM : ObservableObject {
    
    @Published var currentUser : ProfileModel?
    
    //변경된 아이디, 닉네임, 상태메시지
    @Published var username : String = ""
    @Published var profile_name : String = ""
    @Published var profile_message : String = ""
    
    //변경된 아이디가 가능한지의 여부
    @Published var usernameVerify = false
    
    @Published var isLoading = false
    
    private var cancellable = Set<AnyCancellable>()
    
    
    init(){
        AuthorizationService.share.$currentUser
            .sink { [weak self] myInfo in
                self?.currentUser = myInfo
            }
            .store(in: &cancellable)
        
        
    }
    
    
    //update profile
    func profileEdit(profile_image: UIImage?, background_image: UIImage?){
        
        isLoading = true
        
        let url = "https://chatty.kr/api/v1/user/profile"
        
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json", "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
        //현재 모델값들 넣어줌 -> 변경사항을 파라미터로 보내줌
        let parameters: [String: Any] = [
            "username" : username,
            "profile_name": profile_name,
            "profile_message": profile_message
        ]
        
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
                if let profile_image_data = profile_image?.jpegData(compressionQuality: 1) {
                    multipartFormData.append(profile_image_data, withName: "profile_image", fileName: "\(self.currentUser?.username ?? "").jpg", mimeType: "image/jpg")
                }
                if let background_image_data = background_image?.jpegData(compressionQuality: 1) {
                    multipartFormData.append(background_image_data, withName: "background_image", fileName: "\(self.currentUser?.username ?? "").jpg", mimeType: "image/jpg")
                }
            },
            to: url,
            method: .put,
            headers: headers
        )
        .response { response in
            self.isLoading = false
            
            switch response.response?.statusCode {
            case 200:
                if self.username != "" {
                    KeyChain.delete(key: "username")
                    KeyChain.create(key: "username", value: self.username)
                }
                
                AuthorizationService.share.fetchUserProfile()
                
                ChattyEventManager.share.showAlter.send("수정이 완료되었습니다!")
            case 401:
                TokenVM().refreshToken() { success in
                    if success {
                        print("refreshToken Success")
                    }
                }
                ChattyEventManager.share.showAlter.send("오류가 발생했습니다.")
            default:
                ChattyEventManager.share.showAlter.send("오류가 발생했습니다.")
            }
        }
    }
    
    //아이디중복확인
    func verifyUsername() {
        AuthorizationService.share.verifyUsername(username: username) { result in
            if result {
                self.usernameVerify = true
            }else{
                self.usernameVerify = false
                ChattyEventManager.share.showAlter.send("사용 불가능한 아이디입니다.")
            }
        }
    }
    
    
    //중복확인버튼 클릭가능 여부체크
    func checkAvailableUserNameButton() -> Bool {
        
        if username.isEmpty { return true}
        if username.count < 4 { return true }
        if username.count > 15 { return true }

        if !usernameVerify { return true }   
        return false
    }
    
    func rankingToggle(){
        let url = "https://chatty.kr/api/v1/user/ranking/toggle"
        
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json",
                   "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
        NetworkManager.shared.RequestServer(url: url, method: .post,headers: headers , encoding: JSONEncoding.default) { result in
            switch result {
            case .success(_):
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
    
    
    //수정하기 버튼 클릭가능여부
    func checkAailableEdit() -> Bool{
        if (self.username.isEmpty || self.usernameVerify) && self.profile_name.count <= 20 && self.profile_message.count < 50 {
            return true
        }
        return false
    }
}
