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
    
    @Published var inputText = ""
    @Published var resultKeyword = ""
    
    var cancellable = Set<AnyCancellable>()
    
    init(){
        bind()
    }
    
    private func bind(){
        $inputText
            .removeDuplicates()
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] text in
                self?.resultKeyword = text
            } )
            .store(in: &cancellable)
    }
    
    func userSearch(page: Int) {
        let url = "https://chatty.kr/api/v1/user/search"
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json", "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
        let params: Parameters = [
            "keyword" : resultKeyword,
            "page" : page
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
