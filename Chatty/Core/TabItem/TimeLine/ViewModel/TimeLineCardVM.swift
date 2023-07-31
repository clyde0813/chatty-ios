
import Foundation

class TimeLineCardVM : ObservableObject {
    
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
    
    func questionReport(question_id: Int) {
        service.questionReport(question_id: question_id) { result in
            if result {
//                isAlterShow.toggle()
            }
        }
    }
    
    func questionDelete(question_id: Int) {
        service.questionDelete(question_id: chatty.pk) {  result in
            if result {
                //UI 이벤트 전달
            }else{
                
            }
        }
    }
}
