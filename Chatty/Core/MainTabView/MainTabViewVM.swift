import Foundation
import Alamofire
import Combine

class MainTabViewVM : ObservableObject {
    
    @Published var currentUser : ProfileModel?
    private var canclerable = Set<AnyCancellable>()
    
    init(){
        AuthorizationService.share.$currentUser
            .sink { [weak self] result in
                self?.currentUser = result
            }
            .store(in: &canclerable)
    }
    
}
