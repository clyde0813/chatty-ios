import Foundation
import Alamofire

class RankingVM : ObservableObject {
    
    @Published var rankingModel : RankingModel? = nil
    
    
    func rankingGet() {
        
        let url = "https://chatty.kr/api/v1/user/ranking"
        
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json"]
        
        
        NetworkManager.shared.RequestServer(url: url, method: .get,headers: headers, encoding: URLEncoding.default) { [weak self] result in
            switch result{
            case .success(let data):
                guard let data = data, let myData = try? JSONDecoder().decode(RankingModel.self, from: data) else {
                    print("RankingVM - rankingGet() : DecodeFail ")
                    return
                }
                self?.rankingModel = myData
                
            case .failure(let errorModel):
                switch errorModel.status_code{
                case 400:
                    print(errorModel)
                default:
                    print("rankingVM() - rankingGet() : Fail \(errorModel)")
                }
                
            }
        }
    }
    
    
}
