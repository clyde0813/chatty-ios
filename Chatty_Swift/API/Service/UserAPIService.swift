//
//  AuthAPIService.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/01/24.
//

import Foundation
import Alamofire
import Combine

enum UserAPIService {
    static func fetchUserInfo() -> AnyPublisher<UserInfoResponse , AFError>{
        print("AuthAPIService - register() called")
        
        return ApiClient.shared.session
            .request(UserRouter.fetchUserInfo)
            .publishDecodable(type: UserInfoResponse.self)
            .value()
            .map{
                receivedValue in
                return receivedValue
                
            }.eraseToAnyPublisher()
    }
    
}
