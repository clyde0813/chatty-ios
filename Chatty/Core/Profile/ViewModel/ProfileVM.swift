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
    
    private var cancellable = Set<AnyCancellable>()
    var currentPage : Int? = nil
    
    @Published var blockedUserModel : GenericListModel<ProfileModel>? = nil
    
    //MARK: - Publisher
    var profileEditSuccess = PassthroughSubject<(), Never>()
    
    var userBlockSuccess = PassthroughSubject<(), Never>()
    
    var isBlocked = PassthroughSubject<(),Never>()
    
    //MARK: - 함수
    func reset(){
        ChattyService.share.questionModel = nil
        currentPage = 1
    }
    init(){
        subscribe()
    }
    
    func subscribe(){
        //현재 구독을 하니깐, 안에들어있는데이터인, timeline데이터를 같이 가져오게됌.
        // 또한. 구독후 onAppear에서 getQuestion 을 하니까.
        // timeline데이터가 들어있는 상태에서 또 데이터를 가져오게됌.
        //그래서 profile에 timeline데이터가 들어가있음.
        
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
    
    func cancel(){
        cancellable.removeAll()
    }
    
    //Get Question
    func getQuestion(username: String){
        
        // currentPage 가 1 이면, 새로받아오는거니까
        // ChattyService에 있는 모델을 nil로 일단 해버림.
        //result만 remove하면, next, previos는 그대로니까 다 nil해버리는거임 난
        
        if currentPage == 1 {
            ChattyService.share.questionModel = nil
        }
        ChattyService.share.questionGet(questionType: postTab.rawValue, username: username, page: currentPage!)
    }
    
    
    // Get ProfileModel
    func getProfile(username: String){
        UserService.share.profileGet(username: username)
    }
    
    func checkNextCard(questiondata: ResultDetail){
        
        guard let currentPage = currentPage else { return }
        
        if questionModel?.results.isEmpty == true { return }
        if questionModel?.next == nil { return }
        if questiondata.pk != questionModel?.results.last?.pk { return }
        
        self.currentPage = currentPage + 1
        getQuestion(username: questiondata.profile.username)
        
    }
    
    
    //MARK: 하단부분은 삭제할 항목
    
    //Get profile
    func profileGet(username: String){
        let url = "https://chatty.kr/api/v1/user/profile/\(username)"

        var headers : HTTPHeaders = []

        headers = ["Content-Type":"application/json", "Accept":"application/json",
                   "Authorization": "Bearer " + (KeyChain.read(key: "access_token") ?? "")  ]

        NetworkManager.shared.RequestServer(url: url, method: .get, headers: headers, encoding: URLEncoding.default){ [weak self] result in

            switch result {

            case .success(let data):

                guard let data = data else {return}
                guard let data = try? JSONDecoder().decode(ProfileModel.self, from: data) else { return }

                print("ProfileVM - profileGet() : Success ")

                self?.profileModel = data

            case .failure(let errorModel):
                switch errorModel.status_code{
                case 400:
                    print("ProfileVM - profileGet() : Fail \(errorModel)")
                case 500:
                    print("ProfileVM - profileGet() : Fail \(errorModel)")
                case 401:
                    TokenVM.share.refreshToken { result in
                        if result {
                            print("refreshToken reset!")
                        }
                    }
                default:
                    print("ProfileVM - profileGet() : Fail \(errorModel)")
                }

            }
        }
    }
    
    //update profile
    func profileEdit(username: String, profile_name: String, profile_message: String, profile_image: UIImage?, background_image: UIImage?){
        let url = "https://chatty.kr/api/v1/user/profile"
        
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json", "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
        let parameters: [String: Any] = [
            "username" : username,
            "profile_name": profile_name,
            "profile_message": profile_message
        ]
        
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
                if let profile_image_data = profile_image?.jpegData(compressionQuality: 1) {
                    multipartFormData.append(profile_image_data, withName: "profile_image", fileName: "\(username).jpg", mimeType: "image/jpg")
                }
                if let background_image_data = background_image?.jpegData(compressionQuality: 1) {
                    multipartFormData.append(background_image_data, withName: "background_image", fileName: "\(username).jpg", mimeType: "image/jpg")
                }
            },
            to: url,
            method: .put,
            headers: headers
        )
        .response { response in
            switch response.response?.statusCode {
            case 200:
                if username != "" {
                    KeyChain.delete(key: "username")
                    KeyChain.create(key: "username", value: username)
                }
                self.profileEditSuccess.send()
            case 401:
                TokenVM().refreshToken() { success in
                    if success {
                        self.profileEdit(username: username, profile_name: profile_name, profile_message: profile_message, profile_image: profile_image, background_image: background_image)
                    } else {
                        print("Error with no model")
                    }
                }
            default:
                print("Profile Edit Failed")
            }
        }
    }
    
    //set SumOfQuestion
    func SumOfQuestion() -> Int{
        return (profileModel?.questionCount.answered ?? 0) + (profileModel?.questionCount.unanswered ?? 0) + (profileModel?.questionCount.rejected ?? 0)
    }
    
    //Post Follow
    func Follow(username : String) {
        UserService.share.Follow(username: username) { result in
            if result {
                UserService.share.user?.followState.toggle()
            }else{
                //유저한테 이벤트 전달
            }
        }
    }
    
    //Post UserBlock
    func userBlock(username : String){
        let url = "https://chatty.kr/api/v1/user/block"
        
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json",
                   "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
        let parameters: [String: String] = [
            "username" : username
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .responseData { response in
            switch response.result {
            case .success(_):
                print("ProfileVM - userBlock() : Success")
                self.userBlockSuccess.send()
                self.profileModel?.blockState = true
            case .failure(_):
                print("ProfileVM - userBlock() : Failed")
                print(response)
                if let data = response.data,
                   let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                    print("Error Data : ", errorModel)
                }
            }
        }
    }
    
    //Delete userBlock
    func DeleteUserBlock(username : String){
        let url = "https://chatty.kr/api/v1/user/block"
        
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json",
                   "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
        let parameters: [String: String] = [
            "username" : username
        ]
        
        AF.request(url,
                   method: .delete,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .responseData { response in
            switch response.result {
            case .success(_):
                print("ProfileVM - DeleteUserBlock() : Success")
                
                //차단유저 리스트에서 차단해제 하였을경우를 대비해서
                self.blockedUserModel?.results.removeAll(where: {
                    $0.username == username
                })
                
                //프로필을 들어가서 해제했을경우를 대비해서
                self.profileModel?.blockState.toggle()
                
            case .failure(_):
                print("ProfileVM - DeleteUserBlock() : Failed")
                print(response)
                if let data = response.data,
                   let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                    print("Error Data : ", errorModel)
                }
            }
        }
    }
    
    //Get BlockedUserList
    func blockedUserListGet(){
        let url = "https://chatty.kr/api/v1/user/block"
        
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json",
                   "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .responseDecodable(of: GenericListModel<ProfileModel>.self){ response in
            switch response.result {
            case .success(let data):
                print("profileVM- blockedUserListGet() : Success")
//                if self.blockedUserModel == nil {
                self.blockedUserModel = data
//                }else{
//                    self.blockedUserModel?.results += data.results
//                    self.blockedUserModel?.next = data.next
//                    self.blockedUserModel?.previous = data.previous
//                }
            case .failure(_):
                print("profileVM- blockedUserListGet() : Failed")
                print(response)
                if let data = response.data,
                   let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                    print("Error Data : ", errorModel)
                }
            }
        }
        
    }
    
    

    
}
