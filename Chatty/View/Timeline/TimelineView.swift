import SwiftUI
import Kingfisher


enum Timeline_Hot_Tab {
    case timeline,hotQuestion
}

struct TimelineView: View {
    
    @State var currentTab : Timeline_Hot_Tab =  .timeline
    @StateObject var profileVM = ProfileVM()
    @StateObject var questionVM = QuestionVM()
    @State var profile_image = ""
    @State var isClickedQuestion = false
    @State var currentPage = 1
    
    @State var isSheet = false
    
    @StateObject var eventVM = ChattyEventVM()
    //    @Binding var currentTab : BottomTab
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing){
                VStack{
                    //MARK: - 상단 navBar & Tabbar  -2023.06.03 신현호-
                    VStack{
                        navBar
                        tabChangeBar
                            .background(Rectangle()
                                .fill(Color.white)
                                .shadow(color: Color("Shadow Button"), radius: 3, x: 0, y: 6)
                            )
                        GeometryReader{ proxy in
                            ScrollView(showsIndicators: false){
                                LazyVStack(spacing: 16){
                                    if let timelineList = questionVM.questionModel?.results{
                                        ForEach(timelineList, id:\.pk){ questiondata in
                                            ResponsedCard(width:proxy.size.width-32, questiondata: questiondata, eventVM : eventVM)
                                                .onAppear{
                                                    callNextTimeline(questiondata: questiondata)
                                                }
                                        }
                                    }
                                    
                                }
                                .padding(.top, 10)
                            }
                            .background(Color("Background inner"))
                            // 2023.06.06 Clyde 높이 제한 추가
                            .frame(height: proxy.size.height)
                            .frame(maxHeight: .infinity)
                        }
                        
                    }
                    .blur(radius: isClickedQuestion ? 2 : 0)
                }

                if isClickedQuestion {
                    BlurView()
                        .ignoresSafeArea()
                        .onTapGesture {
                            isClickedQuestion.toggle()
                        }
                        .background(Color("Background Overlay"))
                        .opacity(0.7)
                        .toolbar(.hidden ,for: .tabBar)
                }
                questionButton
                
                    
            }
            .navigationBarHidden(true)
        }
        .onAppear(perform: {
            self.initTimelineView()
        })
        .onReceive(profileVM.$profileModel) { userInfo in
            guard let user = userInfo else { return }
            self.profile_image = user.profileImage
        }
        .onReceive(eventVM.sheetPublisher){
            isSheet = true
        }
        .sheet(isPresented: $isSheet, onDismiss: {isSheet = false}) {
            QuestionOption(eventVM: eventVM)
                .presentationDetents([.fraction(0.4)])
        }
        
    }
    
    
    
    
    
}

extension TimelineView {
    //MARK: - Methods
    
    func initTimelineView() {
        questionVM.questionModel?.results.removeAll()
        self.currentPage = 1
        profileVM.profileGet(username: KeyChain.read(key: "username")!)
        questionVM.timelineGet(page: self.currentPage)
    }
    
    func callNextTimeline(questiondata : ResultDetail){
        print("callNextQuestion() - run")
        
        if questionVM.questionModel?.results.isEmpty == false && questionVM.questionModel?.next != nil && questiondata.pk == questionVM.questionModel?.results.last?.pk{
            self.currentPage += 1
            questionVM.timelineGet(page: self.currentPage)
         }
    }
}

extension TimelineView {
    var navBar : some View {
        HStack{
            NavigationLink {
                ProfileView(username: .constant(KeyChain.read(key: "username")!), isOwner: true)
            } label: {
                KFImage(URL(string: profile_image))
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 40,height: 40)
            }
            Spacer()
            Image("Logo Small")
                .resizable()
                .scaledToFill()
                .frame(width: 32, height: 32)
            Spacer()
            NavigationLink{
                UserSearchView()
            } label: {
                Image(systemName: "magnifyingglass")
                    .fontWeight(.semibold)
                    .font(.system(size: 28))
                    .foregroundColor(Color("Main Secondary"))
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 60)
    }
    
    var tabChangeBar : some View {
        HStack(spacing: 20){
            Spacer()
            ZStack(alignment: .bottom){
                Button(action: {
                    currentTab = .timeline
                }){
                    if currentTab == .timeline {
                        VStack(alignment: .center, spacing: 0){
                            Text("타임라인")
                                .font(Font.system(size: 16, weight: .bold))
                                .accentColor(.black)
                                .padding(.bottom, 9)
                            Rectangle()
                                .fill(Color("Main Secondary"))
                                .frame(width: 50, height: 3)
                        }
                    } else {
                        Text("타임라인")
                            .font(Font.system(size: 16, weight: .semibold))
                            .foregroundColor(Color.gray)
                            .padding(.bottom, 12)
                    }
                }
                .accentColor(.black)
            }
            Spacer()
            ZStack(alignment: .bottom){
                Button(action: {
                    currentTab = .hotQuestion
                }){
                    if currentTab == .hotQuestion {
                        VStack(alignment: .center, spacing: 0){
                            Text("지금 핫한 질문")
                                .font(Font.system(size: 16, weight: .bold))
                                .accentColor(.black)
                                .padding(.bottom, 9)
                            Rectangle()
                                .fill(Color("Main Secondary"))
                                .frame(width: 50, height: 3)
                        }
                    } else {
                        Text("지금 핫한 질문")
                            .font(Font.system(size: 16, weight: .semibold))
                            .foregroundColor(Color.gray)
                            .padding(.bottom, 12)
                    }
                }
                .accentColor(.black)
            }
            Spacer()
        }
        .padding(.top,10)
    }
    
//    var timelineLazyVstack : some View {
//        ScrollView{
//            LazyVStack(spacing: 16){
//
//            }
//        }
//        .background(Color("Background inner"))
//    }
    
    var questionButton : some View {
        VStack(alignment: .trailing){
            if isClickedQuestion {
                VStack(alignment: .trailing){
                    NavigationLink {
                        QuestionDetailView(questionVM : questionVM)
                    } label: {
                        HStack{
                            Image(systemName: "plus")
                            Text("다른 친구에게")
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical,14)
                        .background(.white)
                        .foregroundColor(Color("Main Primary"))
                        .clipShape(RoundedRectangle(cornerRadius: 99))
                        .shadow(color: Color("Shadow Button"), radius: 5, x: 0, y: 6)
                        .font(Font.system(size: 16, weight: .bold))
                    }

                    Button {
                        print("!!")
                    } label: {
                        HStack{
                            Image(systemName: "plus")
                            Text("최근 질문한 친구에게")
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical,14)
                        .background(Color("Main Primary"))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 99))
                        .shadow(color: Color("Shadow Button"), radius: 5, x: 0, y: 6)
                        .font(Font.system(size: 16, weight: .bold))
                    }
                }
                .padding([.bottom, .trailing], 16)
            }else{
                Button {
                    withAnimation {
                        isClickedQuestion = true
                    }
                } label: {
                    NewQuestionButton()
                        .padding([.bottom, .trailing], 16)
                }
            }
        }
    }
}


//struct TimelineView_Previews: PreviewProvider {
//    static var previews: some View {
//        TimelineView().environmentObject(ChattyVM())
//    }
//}
