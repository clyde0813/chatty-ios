//
//  UserVM.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/01/24.
//

import Foundation
import Alamofire
import Combine

class UserVM: ObservableObject {
    var subscription = Set<AnyCancellable>()
    
    @Published var loggedInUser: UserData? = nil
    
    @Published var userInfo : UserInfoResponse? = nil
    
    var loginSuccess = PassthroughSubject<(), Never>()
    
    func register(username:String, password:String, password2:String, email:String){
        print("UserVM : register() called")
        AuthAPIService.register(username: username, password: password, password2: password2, email: email)
            .sink { (completion: Subscribers.Completion<AFError>) in
                print("UserVM completion : \(completion)")
            } receiveValue: { (receivedUser: UserData) in
                self.loggedInUser = receivedUser
            }.store(in: &subscription)
    }
    
    func login(username:String, password:String){
        print("UserVM : register() called")
        AuthAPIService.login(username: username, password: password)
            .sink { (completion: Subscribers.Completion<AFError>) in
                print("UserVM completion : \(completion)")
            } receiveValue: { (receivedUser: UserData) in
                self.loggedInUser = receivedUser
                self.loginSuccess.send()
            }.store(in: &subscription)
    }
    
    func fetchUserInfo(){
        print("UserVM - fetchUserInfo() called")
        UserAPIService.fetchUserInfo()
            .sink { (completion: Subscribers.Completion<AFError>) in
                print("UserVM completion : \(completion)")
            } receiveValue: { (receivedUserInfo: UserInfoResponse) in
                self.userInfo = receivedUserInfo
            }.store(in: &subscription)
    }
}
