import Foundation
import Alamofire

//API Calling Client
final class ApiClient {
    static let shared = ApiClient()
    
    static let BASE_URL = "https://chatty.kr/api/v1"
    
    let interceptors = Interceptor(interceptors: [
        BaseInterceptor()
    ])
    
    let monitors = [APILogger()] as [EventMonitor]
    
    var session: Session
    
    init() {
        print("APIClient - init() called")
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
}
