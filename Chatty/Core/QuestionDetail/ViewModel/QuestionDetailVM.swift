import Alamofire
import Combine
import Foundation

class QuestionDetailVM : ObservableObject {
    
    @Published var userList : GenericListModel<ProfileModel>? = nil
    
    @Published var currentPage : Int = 1
    
    private var cancellable = Set<AnyCancellable>()
    
    var isGetSuccessFollowings = PassthroughSubject<(),Never>()
    
    
    
    init(){
        UserService.share.$userList
            .sink { [weak self] result in
                self?.userList = result
            }
            .store(in: &cancellable)
    }
    
    func getFollowing(){
        guard let username = KeyChain.read(key: "username") else { return }
        
//        guard let currentPage = currentPage else { return }
        
        UserService.share.followGet(username: username, page: currentPage, tab: "followings")
    }
    
    
    func callNextFollowings(lastUser : ProfileModel) {
        
        if userList?.results.isEmpty == true  { return }
        
        if userList?.next == nil  { return }
        
        if userList?.results.last?.username != lastUser.username { return }
        
//        guard let currentPage = currentPage else { return }
        currentPage += 1
        getFollowing()
        
    }
    
    func cancel(){
        cancellable.removeAll()
        UserService.share.userList = nil
        
    }

}
