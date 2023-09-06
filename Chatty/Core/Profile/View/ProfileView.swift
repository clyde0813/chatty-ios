import SwiftUI
import Kingfisher


enum PostTab : String {
    case responsedTab = "responsed"
    case arrivedTab = "arrived"
    case refusedTab = "refused"
}

struct ProfileView: View {
    
    //누구의 프로필인지 식별하기위해.
    let username: String
    @Binding var clickTab : Bool
    
    init(username: String, clickTab : Binding<Bool>){
        self.username = username
        self._clickTab = clickTab
    }
    
    @StateObject var profileVM = ProfileVM()
    
    @Environment(\.dismiss) private var dismiss
    
    @State var msg = ""
    
    @State var showMsg = false
    
    @State var userOptionShow = false
    
    @State var offset: CGFloat = 0
    
    @State var tabBarOffset: CGFloat = 0
    
    @State var titleOffset: CGFloat = 0
  
    @State var questionEditorStatus : Bool = false
    
    @State var isMeBlocked : Bool = false
    
    @Namespace var topID
    
    //MARK: - 광고를 위한 VM
    
    @StateObject private var nativeAds = NativeVM()
    
    @State var isShowAds : Bool = false
    
    @GestureState private var dragOffset = CGSize.zero
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let widthFix = (proxy.size.width - 40) / 3
            ZStack(alignment: .bottomTrailing){
                ScrollViewReader { scrollProxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        // ScrollView content VStack
                        Text("")
                            .frame(width: 0,height: 0)
                            .opacity(0)
                            .id(topID)
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
                                                userOptionShow.toggle()
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
//                                            Button(action:{
//                                                dismiss()
//                                            }){
//                                                Image(systemName: "arrow.left")
//                                                    .font(.system(size:16, weight: .bold))
//                                                    .foregroundColor(Color.white)
//                                                    .background(
//                                                        Circle()
//                                                            .fill(Color("Card Share Background"))
//                                                            .frame(width: 32, height: 32)
//                                                    )
//                                            }
//                                            .padding(.leading, 25)
//                                            .padding(.bottom, 10)

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

                                            Button(action:{
                                                userOptionShow.toggle()
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
                                            .padding(.bottom, 10)
                                            .opacity(profileVM.profileModel?.username == KeyChain.read(key: "username") ? 0 : 1)

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
                                                            profileVM.deleteUserBlock(username: profileVM.profileModel?.username ?? "")
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
                                                    NavigationLink(value: ShareLink.editProfileView) {
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
                                        

                                        if let url = profileVM.profileModel?.urlLink ,url.isEmpty != true {
                                            
                                            Link(destination: URL(string: url)!) {
                                                        HStack(spacing: 2){
                                                            Image(systemName: "link")
                                                            Text(url)
                                                        }
                                                        .font(Font.system(size: 15,weight: .semibold))
                                                        .foregroundColor(.gray)
                                                        .lineLimit(1)

                                        }
                                        
                                        //MARK: - follow/following
                                        HStack{
                                            NavigationLink(value: StackPath.FollowView(username, followTab.follower)) {
                                                Text("\(profileVM.profileModel?.follower ?? 0)")
                                                    .font(Font.system(size: 18, weight: .bold))
                                                    .foregroundColor(.black)
                                                Text("팔로워")
                                                    .font(Font.system(size: 14, weight: .light))
                                                    .padding(.trailing, 20)
                                                    .foregroundColor(.black)
                                            }
                                            
                                            NavigationLink(value: StackPath.FollowView(username, followTab.following)) {
                                                Text("\(profileVM.profileModel?.following ?? 0)")
                                                    .font(Font.system(size: 18, weight: .bold))
                                                    .foregroundColor(.black)
                                                Text("팔로잉")
                                                    .font(Font.system(size: 14, weight: .light))
                                                    .padding(.trailing, 20)
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
                                                profileVM.postTab = .responsedTab
                                            }){
                                                if profileVM.postTab == .responsedTab {
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
                                                    profileVM.postTab = .arrivedTab
                                                }){
                                                    if profileVM.postTab == .arrivedTab {
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
                                                    profileVM.postTab = .refusedTab
                                                }){
                                                    if profileVM.postTab == .refusedTab {
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
                                        if profileVM.questionModel == nil {
                                            VStack(alignment: .center){
                                                Spacer()
                                                ProgressView()
                                                Spacer()
                                            }
                                            .frame(width: proxy.size.width, height: 300)
                                        }
                                        else{
                                            if profileVM.questionModel?.results.isEmpty == true{
                                                VStack(alignment: .center){
                                                    VStack(spacing: 0){
                                                        Text("아직 받은 질문이 없어요!")
                                                            .font(.system(size: 16, weight: .none))
                                                            .padding(.bottom, 13)
                                                        Button(action:{
                                                            UIPasteboard.general.string = "chatty.kr/\(profileVM.profileModel?.username ?? "")"
                                                            ChattyEventManager.share.showAlter.send("복사 완료!")
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
                                                ForEach(Array((profileVM.questionModel?.results ?? [] ).enumerated()), id:\.element.pk){ index, questiondata in
                                                    ResponsedCard(width: proxy.size.width - 32, chatty: questiondata,currentTab : profileVM.postTab)
                                                        .onAppear{
                                                            profileVM.checkNextCard(questiondata: questiondata)
                                                            
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
                    }
                    .onChange(of: clickTab) { tap in
                        print("onChange clickTab")
                        if tap {
                            print(tap)
                            withAnimation {
                                scrollProxy.scrollTo(topID)
                                clickTab = false
                            }
                        }
                    }
                }
                
                if !(profileVM.profileModel?.username == KeyChain.read(key: "username")) && profileVM.profileModel?.blockState == false {
                    Button(action: {
                        self.questionEditorStatus = true
                    }
                    ){
                        NewQuestionButton()
                            .padding([.bottom, .trailing], 16)
                    }
                }
                if showMsg {
                    ProfileErrorView(msg: msg)
                }
                
            }
            .ignoresSafeArea(.all, edges: .top)
            .onAppear{
                profileVM.reset()
                profileVM.subscribe()
                profileVM.getProfile(username: username)
                profileVM.getQuestion(username: username)
            }
            .onDisappear{
                profileVM.cancel()
                profileVM.reset()
            }
            .onChange(of: profileVM.postTab) { newValue in
                profileVM.currentPage = 1
                profileVM.getQuestion(username: username)
            }
            .onReceive(ChattyEventManager.share.showAlter){ result in
                msg = result
                showMsg = true
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                    showMsg = false
                }
            }
            .sheet(isPresented: $userOptionShow, onDismiss: { userOptionShow = false }){
                UserOption(user: profileVM.profileModel!)
                    .presentationDetents([.fraction(0.2)])
            }
            .sheet(isPresented: $questionEditorStatus, onDismiss: { questionEditorStatus = false }){
                QuestionEditor(username: username)
                    .presentationDetents([.fraction(0.45)])
            }
//            .alert(isPresented: $isMeBlocked){
//                Alert(
//                    title: Text("Error"),
//                    message: Text("사용자를 찾을수 없습니다."),
//                    dismissButton: .default(Text("확인"))
//                    {
//                        dismiss()
//                    }
//                )
//            }
            .refreshable {
                profileVM.reset()
                profileVM.getProfile(username: username)
                profileVM.getQuestion(username: username)
            }
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
    let msg : String
    var body: some View{
        VStack{
            Spacer()
            HStack{
                Spacer()
                Text(msg)
                    .frame(width: 310, height: 40)
                    .foregroundColor(Color.white)
                    .background(Color("Error Background"))
                    .cornerRadius(8)
                    .padding(.bottom, 50)
                Spacer()
            }
        }
    }
}

//MARK: - Methods
extension ProfileView{
    
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
