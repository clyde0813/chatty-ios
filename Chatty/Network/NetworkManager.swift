import Foundation
import Alamofire
import Combine
enum NetworkError: Error {
    case clientError(statusCode: Int)
    case serverError(statusCode: Int)
    case unknownError
}
class NetworkManager {
    static let shared = NetworkManager()

    func RequestServer(url :String, method : HTTPMethod, headers : HTTPHeaders? = nil, params : Parameters? = nil, encoding: ParameterEncoding, completion: @escaping (Result<Data?, ErrorModel>) -> Void){
        AF.request(url,
                   method: method,
                   parameters: params,
                   encoding: encoding ,
                   headers: headers
        )
        .response{  response in
            switch response.result {
            case .success(let data) :
                guard let statusCode = response.response?.statusCode else {
                    completion(.failure(ErrorModel(error: "UnKnownError", status_code: nil)))
                    return
                }
                switch statusCode{
                case 200:
                    completion(.success(data))
                case 400,500:
                    if let errorData = response.data, let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: errorData) {
                        completion(.failure(errorModel))
                    }
                    else{
                        completion(.failure(ErrorModel(error: "UnknownError", status_code: nil)))
                    }
                default:
                    completion(.failure(ErrorModel(error: "UnknownError", status_code: nil)))
                }
            case .failure(let error) :
                completion(.failure(ErrorModel(error: error.localizedDescription, status_code: nil)))
            }
        }
    }
}



extension NetworkManager{
    func ErrorHandler(data: Data?){
        guard let errorData = data else { return }
        let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: errorData)
        print("Error Data : ", errorModel as Any )
        
        switch errorModel?.status_code {
        case 400:
            print("400")
        default:
            print("unknown")
        }
        
    }
}
