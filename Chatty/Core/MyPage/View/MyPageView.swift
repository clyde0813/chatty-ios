import SwiftUI
import Kingfisher

enum myPageStack : Hashable{
    case profileView(String)
    case editProfileView(ProfileModel)
    
}

struct MyPageView: View {
    @EnvironmentObject var chattyVM: ChattyVM
    
    @Environment(\.dismiss) private var dismiss
    
    @State var copyButtonPressed : Bool = false
    
    @State private var profilePrivacyEditView : Bool = false
    
    @StateObject var myPageVM = MyPageVM()
    
    @Binding var clickTab : Bool
    
    init(clickTab : Binding<Bool>){
        self._clickTab = clickTab
    }
    
    @State var path = NavigationPath()
    
    
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
                                        
                                        if let currentUser = myPageVM.currentUser {
                                            NavigationLink(value: myPageStack.editProfileView(currentUser)) {
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
//                                            self.copyButtonPressed = true
//                                            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
//                                                self.copyButtonPressed = false
//                                            }
                                        }){
                                            Text("내 링크 복사하기")
                                                .font(Font.system(size: 16, weight: .none))
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(Font.system(size: 16, weight: .none))
                                        }
                                    }
                                    .frame(height: 48)
                                    
                                    NavigationLink {
                                        PrivacyEditView()
                                    } label: {
                                        Text("개인정보 수정")
                                            .font(Font.system(size: 16, weight: .none))
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(Font.system(size: 16, weight: .none))
                                    }
                                    .frame(height: 48)
                                    
                                    //                                HStack{
                                    //                                    Button(action:{
                                    //                                        self.profilePrivacyEditView = true
                                    //                                    }){
                                    //                                        Text("개인정보 수정")
                                    //                                            .font(Font.system(size: 16, weight: .none))
                                    //                                        Spacer()
                                    //                                        Image(systemName: "chevron.right")
                                    //                                            .font(Font.system(size: 16, weight: .none))
                                    //                                    }
                                    //                                }
                                    //                                .frame(height: 48)
                                    
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
//                                    NavigationLink {
//                                        BlockedUsersView(profileVM: myPageVM)
//                                    } label: {
//                                        HStack{
//                                            Text("차단된 IP 및 계정 목록")
//                                                .font(Font.system(size: 16, weight: .none))
//                                            Spacer()
//                                            Image(systemName: "chevron.right")
//                                                .font(Font.system(size: 16, weight: .none))
//                                        }
//                                    }
                                    .frame(height: 48)
                                    NavigationLink {
                                        MyQuestionView()
                                    } label: {
                                        HStack{
                                            Text("질문 모아보기")
                                                .font(Font.system(size: 16, weight: .none))
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(Font.system(size: 16, weight: .none))
                                        }
                                    }
                                    .frame(height: 48)
                                    //                            HStack{
                                    //                                Text("신고 기록 및 처리 상태 확인")
                                    //                                    .font(Font.system(size: 16, weight: .none))
                                    //                                Spacer()
                                    //                                Image(systemName: "chevron.right")
                                    //                                    .font(Font.system(size: 16, weight: .none))
                                    //                            }
                                    //                            .frame(height: 48)
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
                                        chattyVM.logout()
                                    }
                                }
                                .padding([.leading, .trailing], 20)
                                
                                Spacer()
                            }
                            .background(Color.clear)
                        }
                    }

                    if copyButtonPressed {
                        VStack{
                            Spacer()
                            HStack{
                                Spacer()
                                Text("복사 완료!")
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
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
            .navigationDestination(for: myPageStack.self) { result in
                switch result {
                case .editProfileView(var profileModel):
                    ProfileEditView(userProfile: profileModel)
                case .profileView(let username):
                    ProfileView(username: username, clickTab: $clickTab)
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
