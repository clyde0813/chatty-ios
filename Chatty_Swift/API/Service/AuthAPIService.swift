//
//  AuthAPIService.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/01/24.
//

import Foundation
import Alamofire
import Combine

enum AuthAPIService {
    static func register(username: String, password: String, password2: String, email: String) -> AnyPublisher<UserData , AFError>{
        print("AuthAPIService - register() called")
        
        return ApiClient.shared.session
            .request(AuthRouter.register(username: username, password: password, password2: password2, email: email))
            .publishDecodable(type: UserData.self)
            .value()
            .map{
                receivedValue in
                return receivedValue
                
            }.eraseToAnyPublisher()
    }
    
    static func login(username: String, password: String) -> AnyPublisher<UserData , AFError>{
        print("AuthAPIService - login() called")
        return ApiClient.shared.session
            .request(AuthRouter.login(username: username, password: password))
            .publishDecodable(type: UserData.self)
            .value()
            .map{
                receivedValue in
                return receivedValue
                
            }.eraseToAnyPublisher()
    }
}
