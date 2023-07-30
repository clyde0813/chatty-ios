import Foundation
import Combine

class ChattyAppVM : ObservableObject {
    
    @Published var currentUser : ProfileModel? = nil
    
    private var cancellable = Set<AnyCancellable>()
    
    init(){
        subScrive()
        
        AuthorizationService.share.$currentUser
            .sink { [weak self] result in
                self?.currentUser = result
            }
            .store(in: &cancellable)
    }
    
    func subScrive(){
        //키체인에 등록된 username이 없으면 그냥 구독만 시켜머림
        guard let _ = KeyChain.read(key: "username") else { return }
        
        //등록된 username이 있으면 username의 정모를 불러옴
        // 불로온 데이터는 여기에있는 currentUser가 구독하고있기때문에, 성공적으로 받아오면 nil이 아니게됌
        AuthorizationService.share.fetchUserProfile()
    }
}
