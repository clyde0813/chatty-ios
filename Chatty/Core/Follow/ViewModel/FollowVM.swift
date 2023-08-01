import Alamofire
import Combine
import Foundation

class FollowVM : ObservableObject{
    @Published var followlist : GenericListModel<ProfileModel>?? = nil
    
    @Published var profileModel : ProfileModel? = nil
    
    @Published var currentPage : Int? = nil
    
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        UserService.share.$userList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] followModel in
                self?.followlist = followModel
            }
            .store(in: &cancellable)
    }
    
    /**
     username : 현재보고있는 프로필의 username
     */
    func getFollow(username: String, currentTab: followTab){
        if UserService.share.userList == nil {
            currentPage = 1
        }
        UserService.share.followGet(username: username, page: currentPage ?? 1, tab: currentTab.rawValue)
        
    }
    /**
     followData : followmodel의 마지막 데이터와,  profilemodel의 데이터의 일치여부 확인을 위해
     */
    func callNextFollow(username:String, followData : ProfileModel, currentTab: followTab){
        
        
        if followlist??.results.isEmpty == true { return }

        if followlist??.next == nil { return }

        if followData.username != followlist??.results.last?.username { return }

        guard let currentPage = currentPage else { return }

        self.currentPage = currentPage + 1

        getFollow(username: username , currentTab: currentTab)

    }
    
    func cancel(){
        cancellable.removeAll()
    }
    func reset(){
        UserService.share.userList = nil
        currentPage = nil
    }
    
    /**
     username : 내가 팔로우할 사람의 username
     */
    func followPost(username : String) {
        UserService.share.followPost(username: username) { result in
            if result{
                print("follow Success")
            }
        }
    }

}
