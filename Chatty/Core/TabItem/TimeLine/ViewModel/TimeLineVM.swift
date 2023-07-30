import Foundation
import Alamofire
import Combine

class TimeLineVM : ObservableObject {
    
    @Published var timelineData : QuestionModel? = nil
    private var cancellable = Set<AnyCancellable>()
    
    var currentPage : Int? = nil
    
    init(){
        ChattyService.share.$chattyModel
            .receive(on: DispatchQueue.main)
            .assign(to: \.timelineData, on: self)
            .store(in: &cancellable)
        
    }
    
    
    func timelineGet(){
        if currentPage == 1 {
            ChattyService.share.chattyModel = nil
        }
        ChattyService.share.getTimeLine(page: currentPage!)
    }

    
    func checkNextPage(data : ResultDetail){
        guard let new = currentPage else { return }
        
        if timelineData?.results.isEmpty == false && timelineData?.next != nil && data.pk == timelineData?.results.last?.pk{
            print("callNextQuestion() - run")
            currentPage = new + 1
            timelineGet()
        }else {
            print("No if Success")
        }
    }
    
    
    
    func handleQuestionResponse(_ data: Data?) {
        guard let data = data ,let myData = try? JSONDecoder().decode(QuestionModel.self, from: data) else { return }
        
        if timelineData == nil {
            timelineData = myData
        }else {
            timelineData?.results += myData.results
            timelineData?.next = myData.next
            timelineData?.previous = myData.previous
        }
    }
    
    func subscribe(){
        ChattyService.share.$chattyModel
            .receive(on: DispatchQueue.main)
            .assign(to: \.timelineData, on: self)
            .store(in: &cancellable)
    }
    
    func cancel(){
        cancellable.removeAll()
    }
}


