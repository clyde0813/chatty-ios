import Foundation

class CardVM : ObservableObject {
    @Published var chatty : ResultDetail
    
    @Published var isAlterShow = false

    private let service = ChattyService()
    
    init(chatty: ResultDetail) {
        self.chatty = chatty
    }
    
    func likeChatty(){
        service.likedChatty(question_id: chatty.pk) { [weak self] result in
            if result {
                self?.chatty.likeStatus.toggle()
                if self?.chatty.likeStatus == true {
                    self?.chatty.like += 1
                }else{
                    self?.chatty.like -= 1
                }
            }
        }
    }
    
    func questionRefuse(){
        ChattyService.share.questionRefuse(question_id: chatty.pk)
    }
    
    
}
