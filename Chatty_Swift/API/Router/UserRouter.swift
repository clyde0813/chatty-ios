//
//  UserRouter.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/02/28.
//

import Foundation
import Alamofire


enum UserRouter: URLRequestConvertible {
    case fetchUserInfo

    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
        
    }

    var endPoint: String {
        switch self {
        case .fetchUserInfo:
            print("/users/profile/\(KeyChain.read(key: "username")!)")
            return "/users/profile/\(KeyChain.read(key: "username")!)"
        }
    }
        
    var method: HTTPMethod { 
        switch self {
        default:
            return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        default:
            return Parameters()
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        
        var request = URLRequest(url:url)
        
        request.method = method
        
        return request
    }
}

