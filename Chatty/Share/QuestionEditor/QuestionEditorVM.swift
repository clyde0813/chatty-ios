import Foundation

class QuestionEditorVM : ObservableObject {
    
    @Published var username : String
    
    @Published var content = ""
    
    @Published var anonymous = true
    
    init(username:String){
        self.username = username
    }
    
    func questionPost(){
        ChattyService.share.questionPost(username: username, content: content, anonymous: anonymous) { result in
            if result {
                ChattyEventManager.share.showAlter.send("질문 보내기 성공!")
            }
        }
    }
}
