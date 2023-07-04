import Foundation
import Combine

class ChattyEventVM : ObservableObject {
    
    var data : ResultDetail? = nil
    
    //본인프로필sheet
    var mySheetPublisher = PassthroughSubject<(),Never>()
    
    //다른사람 프로필 sheet
    var otherUserSheetPublisher = PassthroughSubject<(),Never>()
    
    //답변sheet
    var answerSheetPublisher = PassthroughSubject<(),Never>()
    
    //사진으로 저장하기 sheet => full
    var ImageSavePublisher = PassthroughSubject<(),Never>()
    
    //삭제하기
    var deletePublisher = PassthroughSubject<(),Never>()
    
    //신고하기
    var reportPublisher = PassthroughSubject<(),Never>()
    
    //거절하기
    var refusePublisher = PassthroughSubject<(),Never>()
    
    //답변하기
    var answerPublisher = PassthroughSubject<(),Never>()
    
    //차단하기
    var userBlockPublisher = PassthroughSubject<(),Never>()
    
    //좋아요
    var likePublisher = PassthroughSubject<(),Never>()
    
    
    
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
    func onClickLike(){
        likePublisher.send()
    }
    
    
    
    //MARK: - push Event In FollowView
    func DeleteFollower(){
        followerDeletePublisher.send()
    }
}
