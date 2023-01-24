//
//  AuthRouter.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/01/24.
//

import Foundation
import Alamofire

// Login, Register, Logout
enum AuthRouter: URLRequestConvertible {
    case register(username: String, password: String, password2:String, email:String)
    case login(username: String, password: String)
    
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
        
    }
    
    var endPoint: String {
        switch self {
        case .register:
            return "/users/register"
        case .login:
            return "/users/login"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default:
            return .post
        }
    }
    
    var parameters: Parameters {
        switch self {
        case let .login(username, password):
            var params = Parameters()
            params["username"] = username
            params["password"] = password
            return params
        case let .register(username, password, password2, email):
            var params = Parameters()
            params["username"] = username
            params["password"] = password
            params["password2"] = password2
            params["email"] = email
            return params
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        
        var request = URLRequest(url:url)
        
        request.method = method
        
        request.httpBody = try JSONEncoding.default.encode(request, with: parameters).httpBody
        print(request)
        return request
    }
}
