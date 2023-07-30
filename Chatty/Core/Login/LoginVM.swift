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
    
    @Published var loginning = false
    
    @Published var username : String = ""
    
    @Published var password : String = ""
    
    func Login(){
        loginning = true
        
        AuthorizationService.share.login(username: username, password: password) { result in
            if result {
                self.loginning = false
            }else {
                //유저에게 에러메시지 출력
                print("")
                self.loginning = false
            }
        }
        
    }
    
    
    
}
