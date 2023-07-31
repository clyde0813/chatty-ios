import Foundation

class PrivacyEditVM : ObservableObject {
    
    func unregister(){
        AuthorizationService.share.unregister { result in
            if result {
                ChattyEventManager.share.showAlter.send("탈퇴 처리되었습니다!")
                KeyChain.delete(key: "username")
                KeyChain.delete(key: "access_token")
                KeyChain.delete(key: "refresh_token")
                UserDefaults.standard.removeObject(forKey: "isLoggedIn")
                
                //추가로 서버로 FCM삭제요청 보내야할수도있음
                
            }else{
                ChattyEventManager.share.showAlter.send("오류가 발생했습니다.")
            }
        }
    }
}
