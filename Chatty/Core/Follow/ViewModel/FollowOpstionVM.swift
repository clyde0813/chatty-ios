import Foundation
import Combine

class FollowOpstionVM : ObservableObject {
    
    @Published var profileModel : ProfileModel
    
    init(profileModel: ProfileModel){
        self.profileModel = profileModel
    }
    
    func deleteFollower(){
        UserService.share.DeleteFollower(username: profileModel.username) { result in
            if result{
                print("팔로워 삭제완료")
            }
        }
    }
}
