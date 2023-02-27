//
//  UserDefaultManager.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/02/28.
//

import Foundation

class UserDefaultManager {
    enum Key: String, CaseIterable {
        case token
    }
    
    static let shared: UserDefaultManager = {
        return UserDefaultManager()
    }()
    
    func clearAll(){
        print("UserDefaultManager - clearAll() called")
        Key.allCases.forEach{ UserDefaults.standard.removeObject(forKey: $0.rawValue)}
    }
    
    func setToken(token: String){
        print("UserDefaultManager - setToken() called")
        UserDefaults.standard.set(token, forKey: Key.token.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func getToken() -> TokenData{
        let token = UserDefaults.standard.string(forKey: Key.token.rawValue) ?? ""
        return TokenData(token: token)
    }
}
