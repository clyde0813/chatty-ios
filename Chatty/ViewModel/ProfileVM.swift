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
    @Published var blockedUserModel : GenericListModel<ProfileModel>? = nil
    
    
    let token = TokenVM()
    
    //MARK: - Publisher
    var profileEditSuccess = PassthroughSubject<(), Never>()
    
    var userBlockSuccess = PassthroughSubject<(), Never>()
    
    var isBlocked = PassthroughSubject<(),Never>()
    
    //MARK: - 함수
    //Get profile
    func profileGet(username: String){
        let url = "https://chatty.kr/api/v1/user/profile/\(username)"
        
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json",
                   "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .responseDecodable(of: ProfileModel.self){ response in
            switch response.response?.statusCode {
            case 200 :
                print("Profile get : Success")
                self.profileModel = response.value
            case 400:
                print("Profile get : isBlocked User")
                self.isBlocked.send()
            default:
                print("Profile get : Failed")
                print(response)
                if let data = response.data,
                   let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                    print("Error Data : ", errorModel)
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
        let url = "https://chatty.kr/api/v1/user/follow"
        
        var headers : HTTPHeaders = []
        headers = ["Content-Type":"application/json", "Accept":"application/json", "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
        let parameters: [String: String] = [
            "username" : username
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .response{ response in
            switch response.response?.statusCode {
            case 201 :
                print("실패")
            case 200:
                print("성공")
            default :
                print("error")
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
