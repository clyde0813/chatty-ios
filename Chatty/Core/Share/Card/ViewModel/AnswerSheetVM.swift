import Foundation

class AnserSheetVM : ObservableObject {
    
    let chatty : ResultDetail
    
    @Published var content = ""
    
//    @Published var anonymous = false
    
    init(chatty: ResultDetail){
        self.chatty = chatty
    }
    
    
    func answerQuestion(){
        ChattyService.share.answerPost(question_id: chatty.pk, content: content) { result in
            if result{
                ChattyEventManager.share.showAlter.send("답변 완료!")
            }else{
                ChattyEventManager.share.showAlter.send("잠시후 다시시도해주세요")
            }
        }
    }
    
}

