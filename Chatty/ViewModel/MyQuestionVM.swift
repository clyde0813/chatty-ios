import Foundation
import Combine
import Alamofire

class MyQuestionVM : ObservableObject {
    
    @Published var myQuestionModel : GenericListModel<ResultDetail>? = nil
    
    init(){
        fetchGetQuestion()
    }
    
    func fetchGetQuestion(){
        NetworkManager.shared.fetchGetQuestion { [weak self] result in
            switch result {
            case .success(let data):
                self?.myQuestionModel = data
            case .failure(let error):
                
                print("MyQuestionVM - fetchGetQuestion(): Fail")
                
                guard let afError = error as? AFError, let statusCode = afError.responseCode else { return }
                
                if statusCode > 400 && statusCode < 500 {
                    print("MyQuestionVM - fetchGetQuestion(): \(statusCode)")
                }
                else {
                    print("MyQuestionVM - fetchGetQuestion(): networkError")
                }
                
            }
        }
    }
        
                
    
    
    func GetNextQuestion(){
        
    }
    
    //ViewDisappear
    func cleanSet(){
        
    }
    
}
