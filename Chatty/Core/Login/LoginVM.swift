//
//  LoginVM.swift
//  Chatty
//
//  Created by Clyde on 2023/05/30.
//

import Alamofire
import Combine
import Foundation


class LoginVM : ObservableObject {
    
    var isLoginSuccess = PassthroughSubject<Bool, Never>()
    
    @Published var username : String = ""
    
    @Published var password : String = ""
    
    func Login(){
        AuthorizationService.share.login(username: username, password: password) { result in
            if result {
                //gogo Main
            }else {
                //유저에게 에러메시지 출력
                print("")
            }
        }
    }
    
    
    
}
