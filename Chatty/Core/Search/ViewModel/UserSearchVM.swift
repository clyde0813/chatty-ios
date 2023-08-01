import Foundation
import Alamofire
import Combine
import Foundation

class UserSearchVM: ObservableObject {
    @Published var searchResult : GenericListModel<ProfileModel>? = nil
    
    @Published var inputText = ""
    @Published var resultKeyword = ""
    
    private var cancelable = Set<AnyCancellable>()
    
    
    func bind(){
        $inputText
            .removeDuplicates()
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] text in
                self?.resultKeyword = text
            } )
            .store(in: &cancelable)
        
        UserService.share.$userList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] searchResult in
                self?.searchResult = searchResult
            }
            .store(in: &cancelable)
    }
    
    /*
     궂이 userSearch()의 결과를 UserService.share.userlist에 넣어주는 이유는
     검색결과를 타고 해당유저 프로필에서 팔로우를 누르고,
     검색페이지로 돌아가면, userlist의 변화를 감지하지못해서 이렇게하려고했는데,
     disappear항ㄹ떄 검색키워드를 그냥 초기화시켜버려서 궂이이렇게 안해줘도됌..
     근데 만들어놧으니 그냥 이렇게할게임...ㅋㅋ
     */
    func userSearch(page: Int) {
        let url = "https://chatty.kr/api/v1/user/search"
        var headers : HTTPHeaders = []
        
        headers = ["Content-Type":"application/json", "Accept":"application/json", "Authorization": "Bearer " + KeyChain.read(key: "access_token")!]
        
        let params: Parameters = [
            "keyword" : resultKeyword,
            "page" : page
        ]
        
        NetworkManager.shared.RequestServer(url: url, method: .get,headers: headers,params: params, encoding: URLEncoding.default) { result in
            switch result {
            case .success(let data):
                UserService.share.handleQuestionResponse(data)
            case .failure(let errorModel):
                switch errorModel.status_code{
                case 400:
                    print("ProfileVM - profileGet() : Fail \(errorModel)")
                case 500:
                    print("ProfileVM - profileGet() : Fail \(errorModel)")
                case 401:
                    TokenVM.share.refreshToken { result in
                        if result {
                            print("refreshToken reset!")
                        }
                    }
                default:
                    print("ProfileVM - profileGet() : Fail \(errorModel)")
                }
            }
        }
    }

    
    func followPost(username: String){
        UserService.share.followPost(username: username) { result in
            if result{
                print("UserSearchVM : followPost() - Success")
            }
        }
    }
    
    func cancle(){
        UserService.share.userList = nil
        cancelable.removeAll()
    }
}
