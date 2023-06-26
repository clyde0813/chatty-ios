import Foundation
import Combine

class ChattyEventVM : ObservableObject {
    
    var data : ResultDetail? = nil
    
    var mySheetPublisher = PassthroughSubject<(),Never>()
    
    var otherUserSheetPublisher = PassthroughSubject<(),Never>()
    
    var answerSheetPublisher = PassthroughSubject<(),Never>()

    var ImageSavePublisher = PassthroughSubject<(),Never>()
    
    var deletePublisher = PassthroughSubject<(),Never>()
    
    var reportPublisher = PassthroughSubject<(),Never>()
    
    var refusePublisher = PassthroughSubject<(),Never>()
    
    var answerPublisher = PassthroughSubject<(),Never>()
    
    var userBlockPublisher = PassthroughSubject<(),Never>()
    
    //MARK: - Follower / Followings Event
    
    var followerData : ProfileModel? = nil
    
    var followerDeletePublisher = PassthroughSubject<(),Never>()
    
    
    
    //MARK: - push Event In ProfileView
    func ShowSheet(){
        mySheetPublisher.send()
    }
    func ShowOtherUserSheet(){
        otherUserSheetPublisher.send()
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
    func userBlock(){
        userBlockPublisher.send()
    }
    
    
    
    //MARK: - push Event In FollowView
    func DeleteFollower(){
        followerDeletePublisher.send()
    }
}
