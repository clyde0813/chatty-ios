import Foundation
import Combine
import SwiftUI
import Alamofire

class ProfileEditVM : ObservableObject {
    
    @Published var currentUser : ProfileModel?
    
    //변경된 아이디, 닉네임, 상태메시지, Url
    @Published var username : String? = ""
    @Published var profile_name : String? = ""
    @Published var profile_message : String? = ""
    @Published var urlString : String? = ""
    
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
        
        username = currentUser?.username ?? nil
        profile_name = currentUser?.profile_name ?? nil
        urlString = currentUser?.urlLink ?? nil
        profile_message = currentUser?.profileMessage ?? nil
        
    }
    
    
    //update profile
    //MARK: - 추가로 하이퍼링크 추가 해야함.
    func profileEdit(profile_image: UIImage?, background_image: UIImage?){
        
        isLoading = true
        
        var parameters: [String: Any] = [:]
        
        if username != currentUser?.username {
            parameters["username"] = username!
        }
        
        if profile_name != currentUser?.profile_name {
            parameters["profile_name"] = profile_name!
        }
        
        if profile_message != currentUser?.profileMessage {
            parameters["profile_message"] = profile_message!
             
        }
        
        if urlString != currentUser?.urlLink {
            parameters["link"] = urlString!
        }

        
        let url = "https://chatty.kr/api/v1/user/profile"
        
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json", "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
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
            method: .post,
            headers: headers
        )
        .response { response in
            self.isLoading = false
            print(response.response?.statusCode)
            debugPrint(response)
            switch response.response?.statusCode {
            case 200:
                KeyChain.delete(key: "username")
                KeyChain.create(key: "username", value: self.username ?? "")
    
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
        AuthorizationService.share.verifyUsername(username: username ?? "") { result in
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
        
        if username?.isEmpty == true { return true}
        if let nameCount = username?.count  {
            if nameCount < 4 || nameCount > 15 {
                return true
            }
        }
//        if username?.count < 4 { return true }
//        if username.count > 15 { return true }

        //false일시 중복확인요청 가능
        return false
    }
    
    //수정하기 버튼 클릭가능여부
    func checkAailableEdit() -> Bool{
//        if username == currentUser?.username { usernameVerify = true }
        if (urlString != currentUser?.urlLink) || (profile_name != currentUser?.profile_name) || (profile_message != currentUser?.profileMessage) || (usernameVerify) {
            if let profileNameCount = profile_name?.count , let messageCount = profile_message?.count {
                if profileNameCount <= 20 && messageCount < 50 {
                    return true
                }
            }
//            if profile_name.count <= 20 && profile_message.count < 50 {
//                return true
//            }
            
        }
//        if (self.username.isEmpty || self.usernameVerify) && self.profile_name.count <= 20 && self.profile_message.count < 50 {
//            return true
//        }
        return false
    }
}
