//
//  SearchUserVM.swift
//  Chatty
//
//  Created by Clyde on 2023/06/11.
//

import Foundation
import Alamofire
import Combine
import Foundation

class UserSearchVM: ObservableObject {
    @Published var genericListModel : GenericListModel<ProfileModel>? = nil
    
    func userSearch(keyword: String) {
        let url = "https://chatty.kr/api/v1/user/search"
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json"]
        
        let params: Parameters = [
            "keyword" : keyword
        ]
        
        AF.request(url,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default,
                   headers: headers)
        .responseDecodable(of: GenericListModel<ProfileModel>.self){ response in
            switch response.result {
            case .success(let data):
                print("userSearch() - success")
                if self.genericListModel == nil {
                    self.genericListModel = data
                }else{
                    self.genericListModel?.results += data.results
                    self.genericListModel?.next = data.next
                    self.genericListModel?.previous = data.previous
                }
                if data.results.isEmpty{
                    print("Data empty")
                    //                    self.isSuccessGetQuestion.send(false)
                }else{
                    print("Data exist")
                    //                    self.isSuccessGetQuestion.send(true)
                }
                
            case .failure(_):
                print("UserSearch() - Failed")
            }
        }
    }
}
