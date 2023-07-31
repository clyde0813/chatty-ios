import Foundation
import Combine

class MyPageVM : ObservableObject {
 
    @Published var currentUser : ProfileModel?
    
    private var cancellable = Set<AnyCancellable>()
    
    func logout(){
        AuthorizationService.share.logout()
    }
    
    func reset(){
        AuthorizationService.share.$currentUser
            .sink { [weak self] result in
                self?.currentUser = result
            }
            .store(in: &cancellable)
        
        AuthorizationService.share.fetchUserProfile()
    }
    
    func cancel(){
        cancellable.removeAll()
        currentUser = nil
    }
    
    
}
