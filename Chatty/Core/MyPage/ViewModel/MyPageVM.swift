import Foundation
import Combine

class MyPageVM : ObservableObject {
 
    @Published var currentUser : ProfileModel?
    
    private var cancellable = Set<AnyCancellable>()
    
    init(){
        AuthorizationService.share.$currentUser
            .sink { [weak self] result in
                self?.currentUser = result
            }
            .store(in: &cancellable)
    }
    
    
}
