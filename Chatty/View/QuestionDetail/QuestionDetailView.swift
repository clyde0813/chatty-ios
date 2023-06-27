import SwiftUI
import Kingfisher
enum QuestionDetailTab : String {
    case following = "followings"
    case ranker = "rankings"
}

struct QuestionDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State var currentTab : QuestionDetailTab = .following
    
    @State var isProgressBar = true
    
    @State var questionEditorStatus = false
    
    @State var currentPage = 1
    
    @State var responser = ""
    
    @State var questionAlterShow = false
    
    @StateObject var questionDetailVM = QuestionDetailVM()
    
    @ObservedObject var questionVM : QuestionVM
    
    var body: some View {
        ZStack{
            VStack{
                VStack{
                    navBar
                    tabChangeBar
                }
                .background(Rectangle()
                    .fill(Color.white)
                    .shadow(color: Color("Shadow Button"), radius: 3, x: 0, y: 6)
                )
                currentTabList
                Spacer()
            }
            if questionAlterShow{
                ErrorView(message: "질문 보내기 성공!")
            }
        }
        
            
            
        
        .onAppear{
            initQuestionDetailView()
        }
        .sheet(isPresented: $questionEditorStatus,onDismiss:{
            questionEditorStatus = false
        }){
            QuestionEditor(username: $responser, questionVM: questionVM)
                .presentationDetents([.fraction(0.45)])
        }
        .toolbar(.hidden)
    }
}

extension QuestionDetailView {
    var navBar : some View {
        HStack(spacing: 25){
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(Color.black)
                    .fontWeight(.semibold)
                    .font(Font.system(size: 16, weight: .bold))
            }
            Spacer()
            Text("질문하기")
                .font(.system(size: 18))
                .fontWeight(.medium)
                .foregroundColor(.black)
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(Color.black)
                    .fontWeight(.semibold)
                    .font(Font.system(size: 16, weight: .bold))
            }
            .opacity(0)
        }
        .padding(.horizontal,24)
        .padding(.vertical,14)
    }
    
    var tabChangeBar : some View {
        HStack(spacing: 20){
            Spacer()
            ZStack(alignment: .bottom){
                Button(action: {
                    self.currentTab = .following
                }){
                    if self.currentTab == .following {
                        VStack(alignment: .center, spacing: 0){
                            Text("팔로잉")
                                .font(Font.system(size: 16, weight: .bold))
                                .accentColor(.black)
                                .padding(.bottom, 9)
                            Rectangle()
                                .fill(Color("Main Secondary"))
                                .frame(width: 50, height: 3)
                        }
                    } else {
                        VStack{
                            Text("팔로잉")
                                .font(Font.system(size: 16, weight: .semibold))
                                .foregroundColor(Color.gray)
                            Rectangle()
                                .fill(Color("Main Secondary"))
                                .frame(width: 50, height: 0)
                        }
                    }
                }
                .accentColor(.black)
            }
            Spacer()
//            ZStack(alignment: .bottom){
//                Button(action: {
//                    self.currentTab = .ranker
//                }){
//                    if self.currentTab == .ranker {
//                        VStack(alignment: .center, spacing: 0){
//                            Text("랭커")
//                                .font(Font.system(size: 16, weight: .bold))
//                                .accentColor(.black)
//                                .padding(.bottom, 9)
//                            Rectangle()
//                                .fill(Color("Main Secondary"))
//                                .frame(width: 50, height: 3)
//                        }
//                    } else {
//                        VStack{
//                            Text("랭커")
//                                .font(Font.system(size: 16, weight: .semibold))
//                                .foregroundColor(Color.gray)
//                            Rectangle()
//                                .fill(Color("Main Secondary"))
//                                .frame(width: 50, height: 0)
//                        }
//
//                    }
//                }
//                .accentColor(.black)
//            }
//            Spacer()
        }
        .padding(.top,10)
    }
    
    var currentTabList : some View {
        GeometryReader{ proxy in
            ScrollView(showsIndicators: false){
                LazyVStack(spacing: 0){
                    if isProgressBar {
                        VStack{
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }
                    else{
                        if let followingList = questionDetailVM.followingModel?.results {
                            if self.currentTab == .following {
                                ForEach(followingList, id:\.username) { following in
                                    Button {
                                        responser = following.username
                                        questionEditorStatus = true
                                    } label: {
                                        HStack(spacing: 24){
                                            HStack{
                                                HStack(spacing: 12){
                                                    KFImage(URL(string: following.profileImage ))
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 48, height: 48)
                                                        .clipShape(Circle())
                                                        .clipped()
                                                        .padding(.trailing, 8)
                                                    
                                                    Text(following.profile_name)
                                                        .font(Font.system(size: 14, weight: .semibold))
                                                        .foregroundColor(Color.black)
                                                }
                                                
                                            }
                                            Spacer()
                                        }
                                        .padding([.leading, .trailing], 32)
                                        .padding([.top, .bottom], 12)
                                    }
                                    .onAppear{
                                        callNextFollowings(followingData: following)
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
            .frame(height: proxy.size.height)
            .frame(maxHeight: .infinity)
            
        }
        .onReceive(questionDetailVM.isGetSuccessFollowings){
            isProgressBar = false
        }
        .onReceive(questionVM.questionPostSuccess) {
            questionAlterShow = true
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                self.questionAlterShow = false
            }
            
        }
        
    }
}

extension QuestionDetailView {
    func initQuestionDetailView() {
        questionDetailVM.followingModel = nil
        self.currentPage = 1
        questionDetailVM.followGet(username: KeyChain.read(key: "username")!, page: currentPage)
    }
    
    func callNextFollowings(followingData : ProfileModel){
        if questionDetailVM.followingModel?.results.isEmpty == false && questionDetailVM.followingModel?.next != nil && followingData.username == questionDetailVM.followingModel?.results.last?.username{
            self.currentPage += 1
            questionDetailVM.followGet(username: KeyChain.read(key: "username")!, page: currentPage)
         }
    }
}
//
//struct QuestionDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        QuestionDetailView()
//    }
//}
