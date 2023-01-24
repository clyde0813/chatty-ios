//
//  BaseInterceptor.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/01/24.
//

import Foundation
import Alamofire

class BaseInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        var request = urlRequest
        
        // api header
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        completion(.success(request))
    }
}
