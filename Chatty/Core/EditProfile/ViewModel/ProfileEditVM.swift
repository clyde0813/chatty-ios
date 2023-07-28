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
    
    init(userProfile: ProfileModel){
        self.currentUser = userProfile
    }
    
    
    //update profile
    func profileEdit(profile_image: UIImage?, background_image: UIImage?){
        
        isLoading = true
        
        //닉네임이 변경되었을시, 해당닉네임을 현재가진 모델에 저장
        if self.profile_name != "" {
            self.currentUser?.profile_name = self.profile_name
        }
        
        //상태메시지 변경시, 해당상태메시지 현재가진 모델에 저장
        if self.profile_message != "" {
            self.currentUser?.profileMessage = self.profile_message
        }

        //MARK: - 문제의 코드 아해 usernameVerify가 true가 ㅁ되면 서버로응답이 정상인데, false이면 응답이 400임. 이유를 못찾는상황
//        self.usernameVerify = true
        
        let url = "https://chatty.kr/api/v1/user/profile"
        
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json", "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
        //현재 모델값들 넣어줌 -> 변경사항을 파라미터로 보내줌
        let parameters: [String: Any] = [
            "username" : self.currentUser?.username ?? "",
            "profile_name": self.currentUser?.profile_name ?? "",
            "profile_message": self.currentUser?.profileMessage ?? ""
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
                AuthorizationService.share.loadUserProfile()
                ChattyEventManager.share.showAlter.send("수정이 완료되었습니다!")
            case 401:
                TokenVM().refreshToken() { success in
                    if success {
                        print("!")
                    }
                }
            default:
                print("Profile Edit Failed")
            }
        }
    }
    
    //아이디중복확인
    func verifyUsername() {
        AuthorizationService.share.verifyUsername(username: username) { result in
            if result {

                self.usernameVerify = true
                self.currentUser?.username = self.username
            }else{
                self.usernameVerify = false

                ChattyEventManager.share.showAlter.send("사용 불가능한 아이디입니다.")
            }
        }
    }
    
    
    //중복확인버튼 클릭가능 여부체크
    func checkAvailableUserNameButton() -> Bool {
        //true일시 중복확인클릭 불가능
        if username.isEmpty { return true}
        if username.count < 4 { return true }
        if username.count > 15 { return true }
        
        //중복확인이완료된경우 더이상클릭못함.

//        if !usernameVerify { return true }

        
        
        //false일시 중복확인요청 가능
        return false
    }
    
    
    //수정하기 버튼 클릭가능여부
    func checkAailableEdit() -> Bool{
        if (self.username.isEmpty || self.usernameVerify) && self.profile_name.count <= 20 && self.profile_message.count < 50 {
            return true
        }
        return false
    }
}
