import SwiftUI

struct MyQuestionView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var myQuestionVM = MyQuestionVM()
    
    @State var currentPage = 1
    
    var body: some View {
        
        VStack{
            navView
                .background(Rectangle()
                    .fill(Color.white)
                    .shadow(color: Color("Shadow Button"), radius: 3, x: 0, y: 6)
                )
            
                ScrollView(showsIndicators: false){
                    LazyVStack(spacing: 16){
                        if myQuestionVM.myQuestionModel == nil {
                            ProgressView()
                        }
                        else {
                            if myQuestionVM.myQuestionModel?.results.isEmpty == true {
                                Text("Nothing send question")
                            }
                            else {
                                ForEach(myQuestionVM.myQuestionModel?.results ?? [], id: \.pk) { result in
                                    QuestionCard(cardWidth: getWindowWidth() - 32 , questionModel: result)
                                        .padding(.top,5)
                                        .padding(.horizontal,20)
                                        .onAppear{
                                            callNextQuestion(questiondata: result)
                                        }
                                }
                                
                            }
                        }
                    }
                }
                .background(Color("Background inner"))
                .refreshable {
                    initMyQuestionView()
                }
            

        }
        .onAppear{
            initMyQuestionView()
        }
        .onDisappear{
            myQuestionVM.myQuestionModel = nil
        }
        .toolbar(.hidden)
    }
}


extension MyQuestionView {
    var navView : some View {
        HStack(spacing: 25){
            Button(action:{
                dismiss()
            }){
                Image(systemName: "arrow.left")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            Text("내가 한 질문")
                .font(.system(size: 18))
                .fontWeight(.medium)
                .foregroundColor(.black)
            Spacer()
        }
        .padding(.horizontal,24)
        .padding(.vertical,14)
    }
    
    
}

extension MyQuestionView {
    
    private func callNextQuestion(questiondata: ResultDetail){
        if myQuestionVM.myQuestionModel?.results.isEmpty == false && myQuestionVM.myQuestionModel?.next != nil && questiondata.pk == myQuestionVM.myQuestionModel?.results.last?.pk{
            print("callNextQuestion() - run")
            self.currentPage += 1
            myQuestionVM.GetMyQuestion(page: currentPage)
        }
        
        
    }
    
    private func initMyQuestionView() {
        print("run itit")
        myQuestionVM.myQuestionModel = nil
        self.currentPage = 1
        myQuestionVM.GetMyQuestion(page: currentPage)
    }
    
    func getWindowWidth() -> CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let mainWindow = windowScene.windows.first else {
                    return 0
                }
        
        let windowWidth = mainWindow.frame.width
        return windowWidth
    }
}
