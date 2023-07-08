import SwiftUI
import Kingfisher

enum PostTab {
    case responsedTab, arrivedTab, refusedTab
}

struct ProfileView: View {
    @EnvironmentObject var chattyVM: ChattyVM
    @StateObject var profileVM = ProfileVM()
    @StateObject var questionVM = QuestionVM()
    
    @StateObject var eventVM = ChattyEventVM()
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var username: String
    
    @State var isOwner: Bool
    
    @State var offset: CGFloat = 0
    
    @State var tabBarOffset: CGFloat = 0
    
    @State var titleOffset: CGFloat = 0
    
    @State var currentPostTab : PostTab = .responsedTab
    
    @State var questionType : String = "responsed"
    
    @State var currentQuestionPage : Int = 1
    
    @State var questionEditorStatus : Bool = false
    
    @State var questionPostSuccess : Bool = false
    
    @State var copyButtonPressed : Bool = false
    
    @State var reportSuccess : Bool = false
    
    @State var refuseSuccess : Bool = false
    
    @State var deleteSuccess : Bool = false
    
    @State var deleteFailure : Bool = false
    
    @State var answerSuccess : Bool = false
    
    @State var userBlockSuccess : Bool = false
    
    @State var showMySheet : Bool = false
    
    @State var showOtherUserSheet : Bool = false
    
    @State var isAnswerSheet : Bool = false
    
    @State var isUserSheet : Bool = false
    
    @State var isMeBlocked : Bool = false
    
    @State var shareQuestionSuccess : Bool = false
    
    //MARK: - 광고를 위한 VM
//    @StateObject var googleAdsVM = NativeViewModel()
    
    @StateObject private var nativeAds = NativeVM()
    
    @State var isShowAds : Bool = false
    
    @GestureState private var dragOffset = CGSize.zero
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let widthFix = (proxy.size.width - 40) / 3
            ZStack(alignment: .bottomTrailing){
                ScrollView(.vertical, showsIndicators: false, content: {
                    // ScrollView content VStack
                    VStack(spacing: 0){

                        GeometryReader { proxy -> AnyView in

                            // Sticky Header...
                            let minY = proxy.frame(in: .global).minY

                            DispatchQueue.main.async {
                                self.offset = minY
                            }

                            return AnyView(
                                ZStack{
                                    KFImage(URL(string: profileVM.profileModel?.backgroundImage ?? ""))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(
                                            width: size.width,
                                            height: minY > 0 ? 180 + minY : 180, alignment: .center
                                        )

                                    HStack(spacing: 0) {
                                        Button(action:{
                                            dismiss()
                                            print("dismiss()")
                                        }){
                                            Image(systemName: "arrow.left")
                                                .font(.system(size:16, weight: .bold))
                                                .foregroundColor(Color.white)
                                                .background(
                                                    Circle()
                                                        .fill(Color("Card Share Background"))
                                                        .frame(width: 32, height: 32)
                                                )
                                        }
                                        .padding(.leading, 25)
                                        .padding(.bottom, 40)
                                        Spacer()

                                        //MARK: - userOption Sheet On
                                        Button(action:{
                                            isUserSheet = true
                                        }){
                                            Image(systemName: "ellipsis")
                                                .font(.system(size:16, weight: .bold))
                                                .foregroundColor(Color.white)
                                                .rotationEffect(.degrees(-90))
                                                .background(
                                                    Circle()
                                                        .fill(Color("Card Share Background"))
                                                        .frame(width: 32, height: 32)
                                                )
                                        }
                                        .padding(.trailing, 25)
                                        .padding(.bottom, 40)
                                        .opacity(profileVM.profileModel?.username == KeyChain.read(key: "username") ? 0 : 1)
                                    }
                                    BlurView()
                                        .opacity(blurViewOpacity())

                                    HStack{
//                                        Button(action:{
//                                            dismiss()
//                                        }){
//                                            Image(systemName: "arrow.left")
//                                                .font(.system(size:16, weight: .bold))
//                                                .foregroundColor(Color.white)
//                                                .background(
//                                                    Circle()
//                                                        .fill(Color("Card Share Background"))
//                                                        .frame(width: 32, height: 32)
//                                                )
//                                        }
//                                        .padding(.leading, 25)
//                                        .padding(.bottom, 10)

                                        Spacer()
                                        VStack(alignment: .center, spacing: 8){
                                            Text("\(profileVM.profileModel?.profile_name ?? "")")
                                                .font(Font.system(size: 18, weight: .bold))
                                                .foregroundColor(Color.white)

                                            Text("답변완료 \(profileVM.profileModel?.questionCount.answered ?? 0)개")
                                                .font(Font.system(size: 14, weight: .bold))
                                                .foregroundColor(Color.white)
                                        }
                                        Spacer()

//                                        Button(action:{
//                                            isUserSheet = true
//                                        }){
//                                            Image(systemName: "ellipsis")
//                                                .font(.system(size:16, weight: .bold))
//                                                .foregroundColor(Color.white)
//                                                .rotationEffect(.degrees(-90))
//                                                .background(
//                                                    Circle()
//                                                        .fill(Color("Card Share Background"))
//                                                        .frame(width: 32, height: 32)
//                                                )
//                                        }
//                                        .padding(.trailing, 25)
//                                        .padding(.bottom, 10)
//                                        .opacity(profileVM.profileModel?.username == KeyChain.read(key: "username") ? 0 : 1)

                                    }
                                    // to slide from bottom added extra 60..
                                    .offset(y: 120)
                                    .offset(y: titleOffset > 100 ? 0 : -getTitleTextOffset())
                                    .opacity(titleOffset < 100 ? 1 : 0)

                                }
                                    .clipped()
                                //offset이 -80 이하일 경우 background image 상단 dismiss 버튼 허용
                                    .allowsHitTesting(-offset > 80 ? false : true)
                                // Stretchy Header...
                                    .frame(height: minY > 0 ? 180 + minY : nil)
                                    .offset(y: minY > 0 ? -minY : -minY < 80 ? 0 : -minY - 80)

                            )}
                        .frame(height: 180)
                        .zIndex(1)
                        
                        
                        // Profile
                        VStack(spacing: 0) {
                            
                            //프로필 정보 영역
                            VStack(alignment: .leading, spacing: 8) {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(spacing: 0){
                                        KFImage(URL(string: profileVM.profileModel?.profileImage ?? ""))
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 110, height: 110)
                                            .clipShape(Circle())
                                            .overlay(Circle()
                                                .stroke(Color.white, lineWidth: 3))
                                            .scaleEffect(getScale())
                                            .padding(.top, -50)
                                        Spacer()
                                        ZStack{
                                            //타인의 프로필일 경우
                                            if profileVM.profileModel?.username != KeyChain.read(key: "username"){
                                                if profileVM.profileModel?.blockState == true{
                                                    Button {
                                                        profileVM.DeleteUserBlock(username: profileVM.profileModel?.username ?? "")
                                                    } label: {
                                                        Text("차단해제")
                                                            .font(.system(size:14, weight: .bold))
                                                            .frame(height: 40)
                                                            .frame(width: 90)
                                                            .foregroundColor(.white)
                                                            .background(
                                                                Capsule()
                                                                    .fill(Color("Grey400"))
                                                                
                                                            )
                                                    }

                                                }
                                                else{
                                                    Button {
                                                        profileVM.Follow(username: profileVM.profileModel?.username ?? "")
                                                        //2022.06.13 -신현호
                                                        profileVM.profileModel?.followState.toggle()
                                                        //2022.06.15 -신현호
                                                        
                                                        if profileVM.profileModel?.followState == true {
                                                            profileVM.profileModel?.follower += 1
                                                        }else{
                                                            profileVM.profileModel?.follower -= 1
                                                        }
                                                        
                                                    } label: {
                                                        if let followState = profileVM.profileModel?.followState {
                                                            if !followState {
                                                                Text("팔로우")
                                                                    .font(.system(size:14, weight: .bold))
                                                                    .frame(height: 40)
                                                                    .frame(width: 90)
                                                                    .foregroundColor(.white)
                                                                    .background(
                                                                        Capsule()
                                                                            .fill(Color("Pink Main"))
                                                                    )
                                                            }else{
                                                                //2022.06.15 -신현호
                                                                Text("팔로우취소")
                                                                    .font(.system(size:14, weight: .bold))
                                                                    .frame(height: 40)
                                                                    .frame(width: 90)
                                                                    .foregroundColor(.white)
                                                                    .background(
                                                                        Capsule()
                                                                            .fill(Color("Grey400"))
                                                                    )
                                                            }
                                                        }
                                                        
                                                        
                                                    }
                                                }
                                                
                                            }
                                            
                                            //본인의 프로필일경우
                                            else {
                                                NavigationLink {
                                                    ProfileEditView(profileVM: profileVM)
                                                } label: {
                                                    Text("프로필 수정")
                                                        .font(.system(size:14, weight: .bold))
                                                        .frame(height: 40)
                                                        .frame(width: 90)
                                                        .foregroundColor(Color("Pink Main"))
                                                        .background(
                                                            Capsule()
                                                                .strokeBorder(Color("Pink Main"), lineWidth: 1)
                                                        )
                                                }
                                            }
                                        }
                                    }
                                    Text(profileVM.profileModel?.profile_name ?? "")
                                        .font(Font.system(size: 20, weight: .semibold))
                                        .padding(.bottom, -4)
                                    Text("@\(profileVM.profileModel?.username ?? "")")
                                        .font(Font.system(size:12, weight: .ultraLight))
                                    if profileVM.profileModel?.profileMessage != nil {
                                        Text(profileVM.profileModel?.profileMessage ?? "")
                                            .font(Font.system(size: 16, weight: .light))
                                        //2022.06.13 -신현호
                                            .lineLimit(3)
                                    }
                                    
                                    //MARK: - follow/following
                                    HStack{

                                        NavigationLink {
                                            FollowView(username: $username, currentTab: followTab.follower , eventVM: eventVM)
                                        } label: {
                                            Text("\(profileVM.profileModel?.follower ?? 0)")
                                                .font(Font.system(size: 18, weight: .bold))
                                                .foregroundColor(.black)
                                            Text("팔로워")
                                                .font(Font.system(size: 14, weight: .light))
                                                .padding(.trailing, 20)
                                                .foregroundColor(.black)
                                        }
                                        
                                        NavigationLink {
                                            FollowView(username: $username, currentTab: followTab.following, eventVM: eventVM)
                                        } label: {
                                            Text("\(profileVM.profileModel?.following ?? 0)")
                                                .font(Font.system(size: 18, weight: .bold))
                                                .foregroundColor(.black)
                                            Text("팔로잉")
                                                .font(Font.system(size: 14, weight: .light))
                                                .foregroundColor(.black)
                                        }
                                    }
                                }
                                .padding([.leading, .trailing], 16)
                                HStack(spacing: 0) {
                                    Spacer()
                                    VStack (alignment: .center) {
                                        Text("\(profileVM.SumOfQuestion())")
                                            .font(Font.system(size: 20, weight: .semibold))
                                        Text("받은 질문 수")
                                            .font(Font.system(size: 14, weight: .ultraLight))
                                    }
                                    .frame(width: widthFix)
                                    Spacer()
                                    VStack (alignment: .center) {
                                        Text("\(profileVM.profileModel?.responseRate ?? 0)%")
                                            .font(Font.system(size: 20, weight: .semibold))
                                        Text("답변률")
                                            .font(Font.system(size: 14, weight: .ultraLight))
                                    }
                                    .frame(width: widthFix)
                                    Spacer()
                                    VStack (alignment: .center) {
                                        Text("\(profileVM.profileModel?.views ?? 0)")
                                            .font(Font.system(size: 20, weight: .semibold))
                                        Text("총 방문자 수")
                                            .font(Font.system(size: 14, weight: .ultraLight))
                                    }
                                    .frame(width: widthFix)
                                    Spacer()
                                }
                                .frame(width: proxy.size.width)
                                .padding(.top, 10)
                            }
                            .overlay(

                                GeometryReader{proxy -> Color in

                                    let minY = proxy.frame(in: .global).minY

                                    DispatchQueue.main.async {
                                        self.titleOffset = minY
                                    }
                                    return Color.clear
                                }
                                    .frame(width: 0, height: 0)

                                ,alignment: .top
                            )
                            
                            //프로필 정보 영역 end
                            VStack(spacing: 0){
                                HStack(alignment: .bottom, spacing: 0){
                                    ZStack(alignment: .bottom){
                                        Button(action: {
                                            self.questionType = "responsed"
                                            currentPostTab = .responsedTab
                                            self.initProfileView()
                                        }){
                                            if currentPostTab == .responsedTab {
                                                VStack(alignment: .center, spacing: 0){
                                                    Text("답변 완료")
                                                        .font(Font.system(size: 14, weight: .bold))
                                                        .accentColor(.black)
                                                        .padding(.bottom, 9)
                                                    Rectangle()
                                                        .fill(Color("Main Secondary"))
                                                        .frame(width: 50, height: 3)
                                                }
                                            } else {
                                                Text("답변 완료")
                                                    .font(Font.system(size: 14, weight: .semibold))
                                                    .foregroundColor(Color.gray)
                                                    .padding(.bottom, 12)
                                            }
                                        }
                                        .accentColor(.black)
                                    }
                                    .frame(width: widthFix, alignment: .bottom)
                                    
                                    ZStack {
                                        if profileVM.profileModel?.username == KeyChain.read(key: "username") {
                                            Button(action: {
                                                currentPostTab = .arrivedTab
                                                self.questionType = "arrived"
                                                self.initProfileView()
                                            }){
                                                if currentPostTab == .arrivedTab {
                                                    VStack(alignment: .center, spacing: 0){
                                                        Text("새 질문")
                                                            .font(Font.system(size: 14, weight: .bold))
                                                            .accentColor(.black)
                                                        Spacer()
                                                        Rectangle()
                                                            .fill(Color("Main Secondary"))
                                                            .frame(width: 50, height: 3)
                                                    }
                                                } else {
                                                    Text("새 질문")
                                                        .font(Font.system(size: 14, weight: .semibold))
                                                        .foregroundColor(Color.gray)
                                                        .padding(.bottom, 12)
                                                }
                                            }
                                            .accentColor(.black)
                                        } else {
                                            Text("새 질문")
                                                .font(Font.system(size: 14, weight: .semibold))
                                                .foregroundColor(Color.gray)
                                                .padding(.bottom, 12)
                                        }
                                    }
                                    .frame(width: widthFix)
                                    
                                    ZStack {
                                        if profileVM.profileModel?.username == KeyChain.read(key: "username") {
                                            Button(action: {
                                                currentPostTab = .refusedTab
                                                self.questionType = "refused"
                                                self.initProfileView()
                                            }){
                                                if currentPostTab == .refusedTab {
                                                    VStack(alignment: .center, spacing: 0){
                                                        Text("거절 질문")
                                                            .font(Font.system(size: 14, weight: .bold))
                                                            .accentColor(.black)
                                                        Spacer()
                                                        Rectangle()
                                                            .fill(Color("Main Secondary"))
                                                            .frame(width: 50, height: 3)
                                                    }
                                                } else {
                                                    Text("거절 질문")
                                                        .font(Font.system(size: 14, weight: .semibold))
                                                        .foregroundColor(Color.gray)
                                                        .padding(.bottom, 12)
                                                }
                                            }
                                            .accentColor(.black)
                                        } else {
                                            Text("거절 질문")
                                                .font(Font.system(size: 14, weight: .semibold))
                                                .foregroundColor(Color.gray)
                                                .padding(.bottom, 12)
                                        }
                                    }
                                    .frame(width: widthFix)
                                }
                            }
                            .padding(.top, 30)
                            .frame(width: proxy.size.width)
                            .background(Color.white)
                            .offset(y: tabBarOffset < 90 ? -tabBarOffset + 90 : 0)
                            .overlay(
                                GeometryReader{reader -> Color in

                                    let minY = reader.frame(in: .global).minY

                                    DispatchQueue.main.async {
                                        self.tabBarOffset = minY
                                    }

                                    return Color.clear
                                }
                                    .frame(width: 0, height: 0)

                                ,alignment: .top
                            )
                            .zIndex(1)
                            
                            
                            ZStack(alignment: .top){
                                Color("Background inner")
                                    .frame(minHeight: 500,
                                           maxHeight: .infinity
                                    )
                                //MARK: - 질문 lazyVstack
                                LazyVStack(spacing: 16){
                                    if questionVM.questionModel == nil {
                                        VStack(alignment: .center){
                                            Spacer()
                                            ProgressView()
                                            Spacer()
                                        }
                                        .frame(width: proxy.size.width, height: 300)
                                    }
                                    else{
                                        if questionVM.questionModel?.results.isEmpty == true{
                                            VStack(alignment: .center){
                                                VStack(spacing: 0){
                                                    Text("아직 받은 질문이 없어요!")
                                                        .font(.system(size: 16, weight: .none))
                                                        .padding(.bottom, 13)
                                                    Button(action:{
                                                        UIPasteboard.general.string = "chatty.kr/\(profileVM.profileModel?.username ?? "")"
                                                        self.copyButtonPressed = true
                                                        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                                                            self.copyButtonPressed = false
                                                        }
                                                    }){
                                                        Text("프로필 링크 복사하기")
                                                            .font(.system(size:16, weight: .bold))
                                                            .frame(height: 40)
                                                            .frame(width: 194)
                                                            .foregroundColor(Color.white)
                                                            .background(
                                                                Capsule()
                                                                    .fill( LinearGradient(gradient: Gradient(colors: [Color("MainGradient1"), Color("MainGradient2"),Color("MainGradient3")]), startPoint: .trailing, endPoint: .leading))
                                                            )
                                                    }
                                                }
                                                .padding(.top, 80)
                                            }
                                            .frame(width: proxy.size.width)
                                            .frame(maxHeight: .infinity)
                                        }
                                        else {
                                            ForEach(Array((questionVM.questionModel?.results ?? [] ).enumerated()), id:\.element.pk){ index, questiondata in
                                                if self.currentPostTab == .responsedTab {
                                                    ResponsedCard(width: proxy.size.width - 32, questiondata: questiondata, eventVM : eventVM)
                                                        .onAppear{
                                                            callNextQuestion(questiondata: questiondata)
                                                        }
                                                }
                                                else if self.currentPostTab == .arrivedTab {
                                                    ArrivedCard(width: proxy.size.width - 32, questionVM: questionVM, questiondata: questiondata, eventVM: eventVM)
                                                        .onAppear{
                                                            callNextQuestion(questiondata: questiondata)
                                                        }
                                                }
                                                else if self.currentPostTab == .refusedTab {
                                                    RefusedCard(width: proxy.size.width - 32, questiondata: questiondata,eventVM : eventVM)
                                                        .onAppear{
                                                            callNextQuestion(questiondata: questiondata)
                                                        }
                                                }
                                                if index % 4 == 0 && index != 0{
                                                    AdBannerView(bannerID: "ca-app-pub-3017845272648516/7121150693", width: proxy.size.width)
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding([.top, .bottom])
                            }
                            .zIndex(0)
                        }
                        .zIndex(-offset > 80 ? 0 : 1)
                    }
                })
                if !(profileVM.profileModel?.username == KeyChain.read(key: "username")) && profileVM.profileModel?.blockState == false {
                    Button(action: {
                        self.questionEditorStatus = true
                    }
                    ){
                        NewQuestionButton()
                            .padding([.bottom, .trailing], 16)
                    }
                }
                
                if questionPostSuccess {
                    ProfileErrorView(msg:"질문 보내기 성공!")
                }
                
                if copyButtonPressed {
                    ProfileErrorView(msg: "복사 완료!")
                }
                
                if refuseSuccess {
                    ProfileErrorView(msg: "질문이 거절되었습니다.")
                }
                
                if reportSuccess {
                    ProfileErrorView(msg: "신고가 접수되었습니다!")
                }
                
                if deleteSuccess {
                    ProfileErrorView(msg: "삭제가 완료되었습니다!")
                }
                
                if userBlockSuccess {
                    ProfileErrorView(msg: "차단이 완료되었습니다!")
                }
                
                if answerSuccess {
                    ProfileErrorView(msg: "답변을 완료했습니다!")
                }
                if deleteFailure {
                    ProfileErrorView(msg: "질문등록 48시간 이후로 삭제가능합니다")
                }
                
            }
            .ignoresSafeArea(.all, edges: .top)
            .onAppear{
                //MARK: - 광고넣넣기전 초기화
//                googleAdsVM.refreshAd()
                nativeAds.refreshAd()
                self.initProfileView()
            }
            .onReceive(questionVM.refuseComplete) {
                self.refuseSuccess = true
                scheduleTimer(duration: 2){
                    self.refuseSuccess = false
                }
            }
            .onReceive(questionVM.reportSuccess) {
                self.reportSuccess = true
                scheduleTimer(duration: 2){
                    self.reportSuccess = false
                }
            }
            .onReceive(questionVM.deleteSuccess) { result in
                if result {
                    self.deleteSuccess = true
                    scheduleTimer(duration: 2){
                        self.deleteSuccess = false
                    }
                }else {
                    self.deleteFailure = true
                    scheduleTimer(duration: 2){
                        self.deleteFailure = false
                    }
                }
                
            }
            .onReceive(questionVM.questionPostSuccess){
                self.questionPostSuccess = true
                scheduleTimer(duration: 2){
                    self.questionPostSuccess = false
                }
            }
            .onReceive(questionVM.answerComplete){
                self.answerSuccess = true
                scheduleTimer(duration: 2){
                    self.answerSuccess = false
                }
            }
            .onReceive(eventVM.deletePublisher){
                questionVM.questionDelete(question_id: eventVM.data?.pk ?? 0)
            }
            .onReceive(eventVM.reportPublisher){
                questionVM.questionReport(question_id: eventVM.data?.pk ?? 0)
            }
            .onReceive(eventVM.refusePublisher){
                questionVM.questionRefuse(question_id: eventVM.data?.pk ?? 0)
            }
            .onReceive(eventVM.answerSheetPublisher){
                isAnswerSheet = true
            }
            .onReceive(eventVM.answerPublisher){
                questionVM.answerPost(question_id: eventVM.data?.pk ?? 0, content: eventVM.data?.answerContent ?? "")
            }
            .onReceive(eventVM.userBlockPublisher){
                profileVM.userBlock(username: profileVM.profileModel?.username ?? "" )
            }
            .onReceive(eventVM.likePublisher){
                questionVM.onClickLike(question_id: eventVM.data?.pk ?? 0)
            }
            .onReceive(eventVM.mySheetPublisher){
                showMySheet.toggle()
            }
            .onReceive(eventVM.otherUserSheetPublisher){
                showOtherUserSheet.toggle()
            }
            .onReceive(eventVM.sharePublisher){
                self.shareQuestionSuccess = true
                scheduleTimer(duration: 2){
                    self.shareQuestionSuccess = false
                }
            }
            .onReceive(profileVM.userBlockSuccess){
                self.userBlockSuccess = true
                scheduleTimer(duration: 2){
                    self.userBlockSuccess = false
                }
            }
            .onReceive(profileVM.isBlocked){
                isMeBlocked = true
            }
            .sheet(isPresented: $showMySheet) {
                QuestionOption(eventVM: eventVM)
                    .presentationDetents([.fraction(0.4)])
                    .onDisappear{
                        showMySheet = false
                    }
            }
            .sheet(isPresented: $showOtherUserSheet) {
                QuestionOption(eventVM: eventVM)
                    .presentationDetents([.fraction(0.2)])
                    .onDisappear{
                        showOtherUserSheet = false
                    }
            }
            .sheet(isPresented: $questionEditorStatus){
                QuestionEditor(username: $username, questionVM: questionVM)
                    .presentationDetents([.fraction(0.45)])
                    .onDisappear{
                        questionEditorStatus = false
                    }
            }
            .sheet(isPresented: $isAnswerSheet) {
                AnswerEditor(eventVM: eventVM)
                    .presentationDetents([.fraction(0.45)])
                    .onDisappear{
                        isAnswerSheet = false
                    }
            }
            .sheet(isPresented: $isUserSheet){
                UserOption(eventVM: eventVM)
                    .presentationDetents([.fraction(0.2)])
                    .onDisappear{
                        isUserSheet = false
                    }
            }
            .alert(isPresented: $isMeBlocked){
                Alert(
                    title: Text("Error"),
                    message: Text("사용자를 찾을수 없습니다."),
                    dismissButton: .default(Text("확인"))
                    {
                        dismiss()
                    }
                )
            }
            .refreshable {
                self.initProfileView()
            }
        }
        .onDisappear{
            questionVM.questionModel = nil
        }
        .navigationBarHidden(true)
        .onTapGesture {
        }
        .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
            if(value.startLocation.x < 20 && value.translation.width > 100) {
                dismiss()
            }
        }))
        .blur(radius: isMeBlocked ? 2 : 0)
        
    }

}

//MARK: - ErrorView
struct ProfileErrorView : View {
    @State var msg : String
    var body: some View{
        VStack{
            Spacer()
            HStack{
                Spacer()
                Text(msg)
                    .frame(width: 310, height: 40)
                    .foregroundColor(Color.white)
                    .background(Color("Error Background"))
                    .cornerRadius(16)
                    .padding(.bottom, 50)
                Spacer()
            }
        }
    }
}

//MARK: - Methods
extension ProfileView{
    private func callNextQuestion(questiondata: ResultDetail){
        print("callNextQuestion() - run")
        if questionVM.questionModel?.results.isEmpty == false && questionVM.questionModel?.next != nil && questiondata.pk == questionVM.questionModel?.results.last?.pk{
            self.currentQuestionPage += 1
            questionVM.questionGet(questionType: questionType,username: username, page: self.currentQuestionPage)
        }
        
        
    }
    
    private func initProfileView() {
        print("run itit")
        questionVM.questionModel = nil
        self.currentQuestionPage = 1
        profileVM.profileGet(username: username)
        questionVM.questionGet(questionType: questionType, username: username, page: self.currentQuestionPage)
    }
    
    private func scheduleTimer(duration: TimeInterval, completion: @escaping () -> Void) {
        Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { timer in
            completion()
        }
    }
}



//MARK: - Offset Methods
extension ProfileView {
    func getOffset()->CGFloat{
        
        let progress = (-offset / 80) * 20
        
        return progress <= 20 ? progress : 20
    }
    
    func getTitleTextOffset()->CGFloat{
        
        // some amount of progress for slide effect..
        let progress = 20 / titleOffset
        
        let offset = 60 * (progress > 0 && progress <= 1 ? progress : 1)
        
        return offset
    }
    
    func getScale()->CGFloat{
        
        let progress = -offset / 80
        
        let scale = 1.8 - (progress < 1.0 ? progress : 1)
        
        // since were scaling the view to 0.8...
        // 1.8 - 1 = 0.8....
        
        return scale < 1 ? scale : 1
    }
    
    func blurViewOpacity()->Double{
        
        let progress = -(offset + 80) / 150
        
        return Double(-offset > 80 ? progress : 0)
    }
}
