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
    

    let token = TokenVM()
    
    var profileEditSuccess = PassthroughSubject<(), Never>()
    
    func profileGet(username: String){
        let url = "https://chatty.kr/api/v1/user/profile/\(username)"
        
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
        .responseDecodable(of: ProfileModel.self){ response in
            switch response.result {
            case .success(let data):
                print("Profile get : Success")
                self.profileModel = data
            case .failure(_):
                print("Profile get : Failed")
                print(response)
                if let data = response.data,
                   let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                    print("Error Data : ", errorModel)
                }
            }
        }
    }
    
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
    
    func SumOfQuestion() -> Int{
        return (profileModel?.questionCount.answered ?? 0) + (profileModel?.questionCount.unanswered ?? 0) + (profileModel?.questionCount.rejected ?? 0)
    }
}
