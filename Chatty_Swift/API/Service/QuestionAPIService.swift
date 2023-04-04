//
//  QuestionAPIService.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/03/24.
//

import Foundation
import Alamofire
import Combine

enum QuestionAPIService {
    static func answered(username: String) -> AnyPublisher<QuestionData, AFError>{
        print("AuthAPIService - register() called")
        
        return ApiClient.shared.session
            .request(QuestionRouter.answered(username))
            .publishDecodable(type: QuestionData.self)
            .value()
            .map{
                receivedValue in
                return receivedValue
                
            }.eraseToAnyPublisher()
    }
    
}
