import Foundation
import Combine

class ChattyEventVM : ObservableObject {
    
    var data : ResultDetail? = nil
    
    var sheetPublisher = PassthroughSubject<(),Never>()
    
    var answerSheetPublisher = PassthroughSubject<(),Never>()
    
    
    
    var ImageSavePublisher = PassthroughSubject<(),Never>()
    
    var deletePublisher = PassthroughSubject<(),Never>()
    
    var reportPublisher = PassthroughSubject<(),Never>()
    
    var refusePublisher = PassthroughSubject<(),Never>()
    
    var answerPublisher = PassthroughSubject<(),Never>()
    
    func ShowSheet(){
        sheetPublisher.send()
    }
    func saveImage(){
        ImageSavePublisher.send()
    }
    func deleteQuestion(){
        deletePublisher.send()
    }
    func reportQuestion(){
        reportPublisher.send()
    }
    func refuseQuestion(){
        refusePublisher.send()
    }
    func answerSheetShow(){
        answerSheetPublisher.send()
    }
    func answerQuestion(){
        answerPublisher.send()
    }
    
    

}
