import Foundation
import Alamofire
import Combine

class AuthorizationService {
    static let share = AuthorizationService()
    
    @Published var currentUser : ProfileModel? = nil
    
    func register(username:String, profilename:String, email:String, password:String, password2:String){
        let url = "https://chatty.kr/api/v1/user/register"

        let params: [String: Any] = [
            "username" : username,
            "profile_name" : profilename,
            "email": email,
            "password": password,
            "password2": password2,
        ]

        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding(options: []),
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
        .responseDecodable(of: UserData.self){ response in
            
            switch response.result {
            case .success(let data) :
                self.successAuth(userData: data)
                
                TokenVM.share.apnsTokenRegister()
                
                self.fetchUserProfile()
                
            case .failure(_) :
                if let data = response.data,
                   let errorModel = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                    print("Error : \(errorModel)")
                    if errorModel.status_code == 400 {
                        print("RegisterVM - register() 400 Error ")
                    } else {
                        print("Error with no model")
                    }
                }
            }
        }
    }
    
    func unregister(completion: @escaping(Bool)->()){
        let url = "https://chatty.kr/api/v1/user/register"
        
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json", "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
        AF.request(url,
                   method: .delete,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .response { response in
            switch response.response?.statusCode {
            case 200:
                completion(true)
            case 401:
                completion(false)
            default:
                completion(false)
            }
            
        }
        
    }
    
    func login(username: String, password : String, completion: @escaping (Bool)->()){
        
        let url = "https://chatty.kr/api/v1/user/login"
        
        let params: [String: Any] = [
            "username" : username,
            "password": password
        ]
        
        var header : HTTPHeaders
        
        header = ["Content-Type":"application/json", "Accept":"application/json"]
        
        NetworkManager.shared.RequestServer(url: url, method: .post, headers: header,params: params, encoding: JSONEncoding(options: [])) { result in
            switch result {
            case .success(let data):
                
                guard let data = data, let data = try? JSONDecoder().decode(UserData.self, from: data) else { return }
                
                self.successAuth(userData: data)
                
                TokenVM.share.refreshToken { result in
                    if result{
                        print("Authorization : TokenRefresh Success")
                    }
                }
                
                self.fetchUserProfile()
                
                completion(true)
                
            case .failure(let errorModel):
                print("LoginVM - login() : Fail \(errorModel)")
                switch errorModel.status_code{
                case 401:
                    print("!")
                default:
                    print("LoginVM - login() : Fail \(errorModel)")
                }
                completion(false)
            }
        }
    }
    
    func fetchUserProfile(){
        print("AuthorizationService - fetchUserProfile run!!!")
        guard let username = KeyChain.read(key: "username") else { return }
        
        let url = "https://chatty.kr/api/v1/user/profile/\(username)"
        
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json",
                   "Authorization": "Bearer " + (KeyChain.read(key: "access_token") ?? "")  ]
        
        NetworkManager.shared.RequestServer(url: url, method: .get, headers: headers, encoding: URLEncoding.default){ result in
            switch result {
            case .success(let data):
                
                guard let data = data else {return}
                guard let data = try? JSONDecoder().decode(ProfileModel.self, from: data) else { return }
                
                self.currentUser = data
                
            case .failure(let errorModel):
                switch errorModel.status_code{
                case 400:
                    print("ProfileVM - profileGet() : Fail \(errorModel)")
                case 500:
                    print("ProfileVM - profileGet() : Fail \(errorModel)")
                case 401:
                    TokenVM.share.refreshToken { result in
                        if result {
                            self.fetchUserProfile()
                        }else{
                            print("Token Refresh Fail!")
                        }
                    }
                default:
                    print("ProfileVM - profileGet() : Fail \(errorModel)")
                }
                
            }
        }
    }
    
    func successAuth(userData : UserData){
        KeyChain.create(key: "access_token", value: userData.access_token)
        KeyChain.create(key: "refresh_token", value: userData.refresh_token)
        KeyChain.create(key: "username", value: userData.username)
        
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
    }
    
    func logout(){
        UserDefaults.standard.setValue(false, forKey: "isLoggedIn")
        TokenVM.share.apnsTokenInitialize(completion: { result in
            if result {
                self.currentUser = nil
                KeyChain.delete(key: "username")
                KeyChain.delete(key: "access_token")
                KeyChain.delete(key: "refresh_token")
                print("deleteToken!Success")
            }
            else{
                print("????")
            }
        })
    }
    
    func verifyUsername(username: String, completion: @escaping (Bool)->()){
        let url = "https://chatty.kr/api/v1/user/profile/\(username)"
        
        AF.request(url,
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
        .response { response in
            switch response.response?.statusCode {
            case 200:
                completion(false)
            case 400:
                //프로필조회했을떄 400이 없는거라, 변경이 가능하다는뜻.
                completion(true)
            default:
                completion(false)
            }
        }
    }
    
    func verifyEmail(email: String, completion: @escaping (Bool)->()){
        let url = "https://chatty.kr/api/v1/user/email/verify"
        
        let params: [String: Any] = [
            "email": email
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding(options: []),
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
        .response { response in
            switch response.response?.statusCode {
            case 200:
                completion(true)
            case 400:
                completion(false)
            default:
                completion(false)
            }
        }
    }
    
    
    
    
}
