import SwiftUI
import Kingfisher

enum followTab :String {
    case follower = "followers"
    case following = "followings"
    
}

struct FollowView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var username : String
    
    @State var currentTab : followTab

    @StateObject var followVM = FollowVM()
    
    @State var currentPage = 1
    
    @State var isProgressBar = true
    
    var body: some View {
        VStack{
            VStack{
                navView
                tabChangeBar
            }
            .background(Rectangle()
                .fill(Color.white)
                .shadow(color: Color("Shadow Button"), radius: 3, x: 0, y: 6)
            )
            
            followList
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .onAppear{
            if currentTab == .follower {
                followVM.followGet(username: username, page: 1,tab: "followers")
            }else if currentTab == .following {
                followVM.followGet(username: username, page: 1,tab: "followings")
            }
        }
        
    }
}



//MARK: - View
extension FollowView {
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
            Text(username)
                .font(.system(size: 18))
                .fontWeight(.medium)
                .foregroundColor(.black)
            Spacer()
        }
        .padding(.horizontal,24)
        .padding(.vertical,14)
    }
    
    var tabChangeBar : some View {
        HStack(spacing: 20){
            Spacer()
            ZStack(alignment: .bottom){
                Button(action: {
                    self.currentTab = .follower
                    self.initFollowView()
                    print(currentTab)
                }){
                    if self.currentTab == .follower {
                        VStack(alignment: .center, spacing: 0){
                            Text("팔로워")
                                .font(Font.system(size: 16, weight: .bold))
                                .accentColor(.black)
                                .padding(.bottom, 9)
                            Rectangle()
                                .fill(Color("Main Secondary"))
                                .frame(width: 50, height: 3)
                        }
                    } else {
                        VStack{
                            Text("팔로워")
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
            ZStack(alignment: .bottom){
                Button(action: {
                    self.currentTab = .following
                    self.initFollowView()
                    print(currentTab)
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
        }
        .padding(.top,10)
    }
    
    var followList : some View {
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
                        if let followList = followVM.followModel?.results {
                            ForEach(followList, id:\.username) { follow in
                                HStack(spacing: 24){
                                    HStack{
                                        //profile image & ID + Profile Name Area
                                        NavigationLink {
                                            ProfileView(username: .constant(follow.username), isOwner: false)
                                        } label: {
                                            HStack(spacing: 12){
                                                KFImage(URL(string:follow.profileImage))
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 48, height: 48)
                                                    .clipShape(Circle())
                                                    .clipped()
                                                    .padding(.trailing, 8)
                                                VStack(alignment: .leading, spacing: 4){
                                                    Text(follow.profile_name)
                                                        .font(Font.system(size: 14, weight: .semibold))
                                                        .foregroundColor(Color.black)
                                                    Text("@\(follow.username)")
                                                        .font(Font.system(size: 11, weight: .light))
                                                        .foregroundColor(Color("Text Light Secondary"))
                                                }
                                            }
                                        }
                                    }
                                    Spacer()
                                    if follow.followState {
                                        Button {
                                            followVM.followPost(username: follow.username)
                                            let index = followVM.followModel?.results.firstIndex(where: {
                                                $0.username == follow.username
                                            })
                                            followVM.followModel?.results[index!].followState.toggle()
                                        } label: {
                                            Text("취소")
                                                .font(Font.system(size: 14, weight: .bold))
                                                .foregroundColor(Color.white)
                                                .frame(width:80, height: 28)
                                                .padding(.vertical,4)
                                                .background(Capsule()
                                                    .foregroundColor(Color("Grey300"))
                                                )
                                        }
                                    } else {
                                        Button {
                                            followVM.followPost(username: follow.username)
                                            let index = followVM.followModel?.results.firstIndex(where: {
                                                $0.username == follow.username
                                            })
                                            followVM.followModel?.results[index!].followState.toggle()
                                        } label: {
                                            Text("팔로우")
                                                .font(Font.system(size: 14, weight: .bold))
                                                .foregroundColor(Color.white)
                                                .frame(width:80, height: 30)
                                                .padding(.vertical,4)
                                                .background(Capsule()
                                                    .foregroundColor(Color("Main Secondary"))
                                                )
                                        }
                                    }
                                }
                                .padding([.leading, .trailing], 32)
                                .padding([.top, .bottom], 12)
                                .onAppear{
                                    callNextFollow(followData: follow)
                                }
                            }
                            .onAppear{
                                print(currentTab)
                            }
                        }
                    }
                }
            }
            // 2023.06.06 Clyde 높이 제한 추가
            .frame(height: proxy.size.height)
            .frame(maxHeight: .infinity)
        }
        .onChange(of: currentTab) { tab in
            self.initFollowView()
        }
        .onReceive(followVM.isGetFollowSuccess){
            isProgressBar = false
        }
        
    }
        
}

//MARK: - Methods
extension FollowView {
    func initFollowView(){
        followVM.followModel = nil
        self.currentPage = 1
        followVM.followGet(username: username, page: self.currentPage, tab: currentTab.rawValue)
    }
    
    func callNextFollow(followData : ProfileModel){
        if followVM.followModel?.results.isEmpty == false && followVM.followModel?.next != nil && followData.username == followVM.followModel?.results.last?.username{
            self.currentPage += 1
            followVM.followGet(username: username, page: currentPage, tab: currentTab.rawValue)
        }
    }
}

