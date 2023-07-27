import Foundation

class UserOptionVM : ObservableObject {
    
    let user : ProfileModel
    
    init(user:ProfileModel){
        self.user = user
    }
    
    func userBlock(){
        UserService.share.userBlock(username: user.username) { result in
            if result{
                ChattyEventManager.share.showAlter.send("\(self.user.profile_name)을 차단했습니다!")
            }else{
                ChattyEventManager.share.showAlter.send("차단에 실패했습니다!")
            }
        }
    }
}
