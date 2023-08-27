import Foundation

class QuestionEditorVM : ObservableObject {
    
    func questionPost(username:String, content:String, anonymous:Bool){
        ChattyService.share.questionPost(username: username, content: content, anonymous: anonymous) { result in
            if result {
                ChattyEventManager.share.showAlter.send("질문 보내기 성공!")
            }
        }
    }
}
