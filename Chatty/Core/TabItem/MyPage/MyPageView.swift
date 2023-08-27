import SwiftUI
import Kingfisher

enum myPageStack : Hashable{
    case allofQuestionView
    case EULAView
    case privacyEditView
    case blockListView
    case settingView
}

struct MyPageView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var myPageVM = MyPageVM()
    
    @Binding var clickTab : Bool
    @Binding var doubleClickTab : Bool
    
    @State var msg = ""
    
    @State var showMsg = false
    
    @State var path = NavigationPath()
    
    init(clickTab : Binding<Bool>, doubleClickTab: Binding<Bool>){
        self._clickTab = clickTab
        self._doubleClickTab = doubleClickTab
    }
    
    var body: some View {
        
        NavigationStack(path: $path){
            GeometryReader{ proxy in
                ZStack{
                    Color.white
                    VStack{
                        navbar
                            .background(Rectangle()
                                .fill(Color.white)
                                .shadow(color: Color("Shadow Button"), radius: 3, x: 0, y: 6)
                            )
                        
                        ScrollView(showsIndicators: false){
                            VStack(alignment: .center, spacing: 0){
                                ZStack{
                                    Color.white
                                    VStack(alignment: .leading, spacing: 0){
                                        HStack{
                                            KFImage(URL(string: myPageVM.currentUser?.profileImage ?? ""))
                                                .resizable()
                                                .scaledToFill()
                                                .clipShape(Circle())
                                                .frame(width: 80, height: 80)
                                                .clipped()
                                            Spacer()
                                        }
                                        .padding(.bottom, 10)
                                        Text(myPageVM.currentUser?.profile_name ?? "" )
                                            .font(Font.system(size: 18, weight: .semibold))
                                            .padding(.bottom, 5)
                                        Text("@\(myPageVM.currentUser?.username ?? "")")
                                            .font(Font.system(size: 12, weight: .none))
                                            .foregroundColor(Color.gray)
                                            .padding(.bottom, 8)
                                        HStack(spacing: 0){
                                            Text("\(myPageVM.currentUser?.follower ?? 0) ")
                                                .font(Font.system(size: 16, weight: .semibold))
                                            Text("팔로워")
                                                .font(Font.system(size: 12, weight: .none))
                                                .padding(.trailing, 16)
                                            Text("\(myPageVM.currentUser?.following ?? 0) ")
                                                .font(Font.system(size: 16, weight: .semibold))
                                            Text("팔로잉")
                                                .font(Font.system(size: 12, weight: .none))
                                        }
                                        .padding(.bottom, 16)
                                        
//
                                        
                                        NavigationLink(value: ShareLink.editProfileView) {
                                            Text("프로필 수정")
                                                .font(.system(size:14, weight: .bold))
                                                .frame(height: 40)
                                                .frame(minWidth: 0,
                                                        maxWidth: .infinity
                                                )
                                                .foregroundColor(Color("Pink Main"))
                                                .background(
                                                    Capsule()
                                                        .strokeBorder(Color("Pink Main"), lineWidth: 1)
                                                )
                                        }

                                    }
                                    .padding(16)
                                }
                                .frame(width: proxy.size.width - 32)
                                .fixedSize(horizontal: false, vertical: true)
                                .mask(RoundedRectangle(cornerRadius: 20))
                                .shadow(color: Color("Shadow Card"), radius: 3, x: 0, y: 7)
                                .padding(.top, 16)
                                .shadow(color: Color("Shadow Button"), radius: 10, x: 8, y: 10)
                                
                                VStack(alignment: .leading, spacing: 0){
                                    HStack{
                                        Button(action:{
                                            UIPasteboard.general.string = "chatty.kr/\(myPageVM.currentUser?.username ?? "")"
                                            ChattyEventManager.share.showAlter.send("복사 완료!")
                                        }){
                                            Text("내 링크 복사하기")
                                                .font(Font.system(size: 16, weight: .none))
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(Font.system(size: 16, weight: .none))
                                        }
                                    }
                                    .frame(height: 48)
                                    
                                    NavigationLink(value: myPageStack.privacyEditView) {
                                        Text("개인정보 수정")
                                            .font(Font.system(size: 16, weight: .none))
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(Font.system(size: 16, weight: .none))
                                    }
                                    .frame(height: 48)
                                    
                                    HStack{
                                        Button(action:{
                                            if let url = URL(string: "mailto:clyde_dev@icloud.com") {
                                                UIApplication.shared.open(url)
                                            }
                                        }){
                                            Text("문의하기")
                                                .font(Font.system(size: 16, weight: .none))
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(Font.system(size: 16, weight: .none))
                                        }
                                    }
                                    .frame(height: 48)
                                    //                            HStack{
                                    //                                Text("고객 지원")
                                    //                                    .font(Font.system(size: 16, weight: .none))
                                    //                                Spacer()
                                    //                                Image(systemName: "chevron.right")
                                    //                                    .font(Font.system(size: 16, weight: .none))
                                    //                            }
                                    //                            .frame(height: 48)
                                    //                            HStack{
                                    //                                Text("공지사항")
                                    //                                    .font(Font.system(size: 16, weight: .none))
                                    //                                Spacer()
                                    //                                Image(systemName: "chevron.right")
                                    //                                    .font(Font.system(size: 16, weight: .none))
                                    //                            }
                                    //                            .frame(height: 48)
                                    //                            HStack{
                                    //                                Text("FAQ")
                                    //                                    .font(Font.system(size: 16, weight: .none))
                                    //                                Spacer()
                                    //                                Image(systemName: "chevron.right")
                                    //                                    .font(Font.system(size: 16, weight: .none))
                                    //                            }
                                    //                            .frame(height: 48)
                                    NavigationLink(value: myPageStack.blockListView) {
                                        HStack{
                                            Text("차단된 IP 및 계정 목록")
                                                .font(Font.system(size: 16, weight: .none))
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(Font.system(size: 16, weight: .none))
                                        }
                                    }
                                    .frame(height: 48)
                                    
                                    
                                    NavigationLink(value: myPageStack.allofQuestionView) {
                                        HStack{
                                            Text("내가 한 질문 모아보기")
                                                .font(Font.system(size: 16, weight: .none))
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(Font.system(size: 16, weight: .none))
                                        }
                                    }
                                    .frame(height: 48)
                                    
                                    NavigationLink(value: myPageStack.settingView) {
                                        HStack{
                                            Text("환경설정")
                                                .font(Font.system(size: 16, weight: .none))
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(Font.system(size: 16, weight: .none))
                                        }
                                    }
                                    .frame(height: 48)
                                    
                                }
                                .padding(.top, 40)
                                .padding([.leading, .trailing], 20)
                                .frame(width: proxy.size.width)
                                
                                VStack(alignment: .leading, spacing: 0){
                                    //                            HStack{
                                    //                                Text("회원 정보")
                                    //                                    .font(Font.system(size: 14, weight: .none))
                                    //                                    .foregroundColor(Color.gray)
                                    //                                Spacer()
                                    //                            }
                                    //                            HStack{
                                    //                                Text("통계")
                                    //                                    .font(Font.system(size: 16, weight: .none))
                                    //                                Spacer()
                                    //                                Image(systemName: "chevron.right")
                                    //                                    .font(Font.system(size: 16, weight: .none))
                                    //                            }
                                    //                            .frame(height: 48)
                                    //                            HStack{
                                    //                                Text("개인정보 수정")
                                    //                                    .font(Font.system(size: 16, weight: .none))
                                    //                                Spacer()
                                    //                                Image(systemName: "chevron.right")
                                    //                                    .font(Font.system(size: 16, weight: .none))
                                    //                            }
                                    //                            .frame(height: 48)
                                    HStack{
                                        Text("로그아웃")
                                            .font(Font.system(size: 16, weight: .none))
                                            .foregroundColor(Color.red)
                                        Spacer()
                                        
                                    }
                                    .frame(height: 48)
                                    .onTapGesture {
                                        myPageVM.logout()
                                    }
                                }
                                .padding([.leading, .trailing], 20)
                                
                                Spacer()
                            }
                            .background(Color.clear)
                        }
                    }
                    
                    if showMsg {
                        MyPageErrorView(msg: msg)
                    }
                    
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
            .toolbar(.hidden)
            .navigationDestination(for: myPageStack.self) { result in
                switch result {
                case .allofQuestionView:
                    MyQuestionView()
                case .privacyEditView:
                    PrivacyEditView()
                case .EULAView:
                    EULAView()
                case .blockListView:
                    BlockedUsersView()
                case .settingView:
                    SettingView(toggleState: AuthorizationService.share.currentUser?.rankState ?? false)
                }
            }
            .navigationDestination(for: ShareLink.self) { result in
                switch result {
                case .profileView(let username):
                    ProfileView(username: username, clickTab: $clickTab)
                case .editProfileView:
                    ProfileEditView()
                }
            }
            .onAppear{
                myPageVM.reset()
            }
            .onDisappear{
                myPageVM.cancel()
            }
            .onChange(of: doubleClickTab) { newValue in
                path = .init()
            }
            .onReceive(ChattyEventManager.share.showAlter) { result in
                msg = result
                showMsg = true
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                    showMsg = false
                }
            }
        }
        
    }
}

extension MyPageView {
    var navbar : some View {
        HStack{
            Spacer()
            Image("Logo Small")
                .resizable()
                .scaledToFill()
                .frame(width: 32, height: 32)
                .padding(.vertical,10)
            Spacer()
        }
    }
}


struct MyPageErrorView : View {
    
    let msg  : String
    
    var body: some View {
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
