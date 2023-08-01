import Foundation

class TimeLineOpstionVM : ObservableObject {
    
    @Published var chatty : ResultDetail
    
    init(chatty: ResultDetail) {
        self.chatty = chatty
    }
    
    func questionReport() {
        ChattyService.share.questionReport(question_id: chatty.pk) {  result in
            if result {
                ChattyEventManager.share.showAlter.send("신고 접수가 완료되었습니다!")
            }
        }
    }
    
    func questionDelete() {
        ChattyService.share.questionDelete(question_id: chatty.pk) {  result in
            if result {
                ChattyEventManager.share.showAlter.send("삭제가 완료되었습니다")
            }else{
                
            }
        }
    }
}


