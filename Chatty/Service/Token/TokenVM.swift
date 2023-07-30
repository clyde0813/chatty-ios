
import Foundation
import Alamofire
import Combine
import Foundation

class TokenVM : ObservableObject {

    static let share = TokenVM()
    
    func apnsTokenInitialize(completion: @escaping (Bool) -> Void) {
        let url = "https://chatty.kr/api/v1/user/FCM/ios"
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json"]
        let params: [String: Any] = [
            "token" : KeyChain.read(key: "fcm_token") ?? ""
        ]
        
        AF.request(url,
                   method: .delete,
                   parameters: params,
                   encoding: JSONEncoding(options: []),
                   headers: headers)
        .response{ response in
            switch response.result {
            case .success(_) :
                print("FCM 토큰 초기화 완료")
                completion(true)
            case .failure(let error) :
                print(error)
                completion(false)
            }
        }
    }
    
    func apnsTokenRegister() {
        let url = "https://chatty.kr/api/v1/user/FCM/ios"
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json", "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        let params: [String: Any] = [
            "token" : KeyChain.read(key: "fcm_token") ?? ""
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding(options: []),
                   headers: headers)
        .response{ response in
            switch response.result {
            case .success(_) :
                print("FCM 등록 완료")
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    func refreshToken(completion: @escaping (Bool) -> Void){
        let url = "https://chatty.kr/api/v1/user/api/token/refresh/"
        
        let params: [String: Any] = [
            "refresh" : String(KeyChain.read(key: "refresh_token") ?? "")
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding(options: []),
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
        .responseDecodable(of: TokenModel.self){ response in
            switch response.result {
            case .success(let token) :
                
                KeyChain.delete(key: "access_token")
                KeyChain.delete(key: "refresh_token")
                
                KeyChain.create(key: "access_token", value: String(token.access))
                KeyChain.create(key: "refresh_token", value: String(token.refresh))
                
                completion(true)
                
            case .failure(_) :
                if let data = response.data,
                   let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                    print("Error : \(errorModel.status_code ?? 600)")
                    if errorModel.status_code == 401 {
                        print("RefreshToken : 401")
                    } else {
                        print("RefreshToken : Error with no model")
                    }
                }
            }
        }
    }
}
