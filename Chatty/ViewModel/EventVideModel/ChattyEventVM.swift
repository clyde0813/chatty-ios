import Foundation
import Combine

class ChattyEventVM : ObservableObject ,Equatable,Hashable {
    static func == (lhs: ChattyEventVM, rhs: ChattyEventVM) -> Bool {
            // EventViewModel의 동등성 비교 로직 구현
            // 예시로 간단히 object identifier를 비교
            return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
        }
    func hash(into hasher: inout Hasher) {
          // EventViewModel의 해시 값 생성
          // 예시로 간단히 object identifier를 사용
          hasher.combine(ObjectIdentifier(self))
      }
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
    
    //카드뷰에서 공유하기 눌렀을때 profileView로 이벤트 전달
    var sharePublisher = PassthroughSubject<(),Never>()
    
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
