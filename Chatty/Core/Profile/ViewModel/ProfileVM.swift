//
//  ProfileVM.swift
//  Chatty
//
//  Created by Clyde on 2023/06/04.
//

import Foundation
import Alamofire
import Combine
import Foundation

class ProfileVM : ObservableObject {    
    
    @Published var profileModel : ProfileModel? = nil
    
    @Published var questionModel : QuestionModel? = nil
    
    @Published var postTab : PostTab = .responsedTab
    
    @Published var currentPage : Int? = nil
    
    private var cancellable = Set<AnyCancellable>()
    

    func subscribe(){
        ChattyService.share.$questionModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] questionModel in
                self?.questionModel = questionModel // 데이터를 할당합니다.
            }
            .store(in: &cancellable)
        
        UserService.share.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] profileModel in
                self?.profileModel = profileModel
            }
            .store(in: &cancellable)
    }
    
    func reset(){
        ChattyService.share.questionModel = nil
        UserService.share.user = nil
        currentPage = 1
    }
    
    
    func cancel(){
        cancellable.removeAll()
    }
    
    func getQuestion(username: String){
        //currentTab 변경시, page는 1로 변경
        //page가 1일시, 기존데이터 삭제후, 다시받아옴.
        if currentPage == 1 {
            ChattyService.share.questionModel = nil
        }
        ChattyService.share.questionGet(questionType: postTab.rawValue, username: username, page: currentPage!)
    }
    
    
    func getProfile(username: String){
        UserService.share.profileGet(username: username)
    }
    
    func Follow(username : String) {
        UserService.share.Follow(username: username) { result in
            if result {
                UserService.share.user?.followState.toggle()
            }else{
                ChattyEventManager.share.showAlter.send("오류가 발생했습니다!ㅠ")
            }
        }
    }
    
    func deleteUserBlock(username:String){
        UserService.share.DeleteUserBlock(username: username) { result in
            if result{
                AuthorizationService.share.fetchUserProfile()
            }else{
                ChattyEventManager.share.showAlter.send("오류가 발생했습니다!ㅠ")
            }
        }
    }
    
    func checkNextCard(questiondata: ResultDetail){
        
        guard let currentPage = currentPage else { return }
        
        if questionModel?.results.isEmpty == true { return }
        if questionModel?.next == nil { return }
        if questiondata.pk != questionModel?.results.last?.pk { return }
        
        self.currentPage = currentPage + 1
        getQuestion(username: questiondata.profile.username)
        
    }
    
    func SumOfQuestion() -> Int{
        return (profileModel?.questionCount.answered ?? 0) + (profileModel?.questionCount.unanswered ?? 0) + (profileModel?.questionCount.rejected ?? 0)
    }
    
    
    

    
}
