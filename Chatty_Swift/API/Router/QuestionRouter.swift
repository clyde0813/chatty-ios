//
//  QuestionRouter.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/03/24.
//
import Foundation
import Alamofire


enum QuestionRouter: URLRequestConvertible {
    case answered(String)
    
    var baseURL: URL {
        return URL(string: ApiClient.BASE_URL)!
    }
    
    var endPoint: String {
        switch self {
        case .answered(let username):
            return "/posts/question/\(username)"
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

