//
//  MyPageView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/02/23.
//

import SwiftUI
import Kingfisher

struct MyPageView: View {
    @EnvironmentObject var chattyVM: ChattyVM
    
    @State var copyButtonPressed : Bool = false
    
    @State private var profilePrivacyEditView : Bool = false
    
    @StateObject var profileVM = ProfileVM()
    
    var body: some View {
        NavigationStack{
            GeometryReader{ proxy in
                ZStack{
                    Color.white
                    ScrollView(showsIndicators: false){
                        VStack(alignment: .center, spacing: 0){
                            HStack{
                                Image("Logo Small")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 32, height: 32)
                            }
                            .frame(width: proxy.size.width, height: 60)
                            .background(Rectangle()
                                .fill(Color.white)
                                .shadow(color: Color("Shadow Button"), radius: 3, x: 0, y: 6)
                            )
                            ZStack{
                                Color.white
                                VStack(alignment: .leading, spacing: 0){
                                    HStack{
                                        KFImage(URL(string: profileVM.profileModel?.profileImage ?? ""))
                                            .resizable()
                                            .scaledToFill()
                                            .clipShape(Circle())
                                            .frame(width: 80, height: 80)
                                            .clipped()
                                        Spacer()
                                    }
                                    .padding(.bottom, 10)
                                    Text(profileVM.profileModel?.profile_name ?? "")
                                        .font(Font.system(size: 18, weight: .semibold))
                                        .padding(.bottom, 5)
                                    Text("@\(profileVM.profileModel?.username ?? "")")
                                        .font(Font.system(size: 12, weight: .none))
                                        .foregroundColor(Color.gray)
                                        .padding(.bottom, 8)
                                    HStack(spacing: 0){
                                        Text("\(profileVM.profileModel?.follower ?? 0) ")
                                            .font(Font.system(size: 16, weight: .semibold))
                                        Text("팔로워")
                                            .font(Font.system(size: 12, weight: .none))
                                            .padding(.trailing, 16)
                                        Text("\(profileVM.profileModel?.following ?? 0) ")
                                            .font(Font.system(size: 16, weight: .semibold))
                                        Text("팔로잉")
                                            .font(Font.system(size: 12, weight: .none))
                                    }
                                    .padding(.bottom, 16)
                                    NavigationLink {
                                        ProfileEditView(profileVM: profileVM)
                                    } label: {
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

//                                    Button(action:{
//                                        chattyVM.profileEditPressed.send()
//                                    }){
//                                        Text("프로필 수정")
//                                            .font(.system(size:14, weight: .bold))
//                                            .frame(height: 40)
//                                            .frame(minWidth: 0,
//                                                   maxWidth: .infinity
//                                            )
//                                            .foregroundColor(Color("Pink Main"))
//                                            .background(
//                                                Capsule()
//                                                    .strokeBorder(Color("Pink Main"), lineWidth: 1)
//                                            )
//                                    }
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
                                        UIPasteboard.general.string = "chatty.kr/\(profileVM.profileModel?.username ?? "")"
                                        self.copyButtonPressed = true
                                        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                                            self.copyButtonPressed = false
                                        }
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
    //                            HStack{
    //                                Text("차단된 IP 및 계정 목록")
    //                                    .font(Font.system(size: 16, weight: .none))
    //                                Spacer()
    //                                Image(systemName: "chevron.right")
    //                                    .font(Font.system(size: 16, weight: .none))
    //                            }
    //                            .frame(height: 48)
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
            .onAppear{
                profileVM.profileGet(username: KeyChain.read(key: "username") ?? "")
//                chattyVM.profileModel = nil
//                chattyVM.profileGet(username: KeyChain.read(key: "username") ?? "")
            }
        }
        
//        .navigationDestination(isPresented: $profilePrivacyEditView){
//            PrivacyEditView()
//        }
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView().environmentObject(ChattyVM())
    }
}
