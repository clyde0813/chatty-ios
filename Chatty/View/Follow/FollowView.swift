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
                LazyVStack(spacing: 16){
                    if isProgressBar {
                        VStack{
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }
                    else{
                        if self.currentTab == .follower {
                            if let followList = followVM.followModel?.results {
                                ForEach(followList, id:\.username) { follow in
                                    HStack(spacing: 24){
                                        NavigationLink {
                                            ProfileView(username: .constant(follow.username),isOwner: false)
                                        } label: {
                                            HStack(spacing: 24){
                                                KFImage(URL(string: follow.profileImage ))
                                                    .resizable()
                                                    .clipShape(Circle())
                                                    .scaledToFill()
                                                    .frame(width: 48, height: 48)
                                                    .clipped()
                                                
                                                Text("\(follow.profile_name)")
                                                    .font(Font.system(size: 16, weight: .bold))
                                            }
                                        }
                                        .buttonStyle(.plain)
                                        Spacer()
                                        if follow.followState == false{
                                            Button {
                                                followVM.followPost(username: follow.username)
                                                let index = followVM.followModel?.results.firstIndex(where: {
                                                    $0.username == follow.username
                                                })
                                                followVM.followModel?.results[index!].followState.toggle()
                                            } label: {
                                                Text("팔로잉")
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
                                                Text("맞팔로워")
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
                                    .padding(.horizontal, 32)
                                    .padding(.vertical,5)
                                    .onAppear{
                                        callNextFollow(followData: follow)
                                    }
                                }
                                .onAppear{
                                    print(currentTab)
                                }
                            }
                        }
                        else if self.currentTab == .following {
                            if let followList = followVM.followModel?.results {
                                ForEach(followList,id:\.username) { following in
                                    HStack(spacing: 24){
                                        NavigationLink {
                                            ProfileView(username: .constant(following.username),isOwner: false)
                                        } label: {
                                            KFImage(URL(string: following.profileImage ))
                                                .resizable()
                                                .clipShape(Circle())
                                                .scaledToFill()
                                                .frame(width: 48, height: 48)
                                                .clipped()
                                        }
                                        Text("\(following.profile_name)")
                                            .font(Font.system(size: 16, weight: .bold))
                                        Spacer()
                                        Text("팔로잉")
                                            .font(Font.system(size: 14, weight: .bold))
                                            .foregroundColor(Color.white)
                                            .frame(width:80, height: 28)
                                            .padding(.vertical,4)
                                            .background(Capsule()
                                                .foregroundColor(Color("Grey300"))
                                            )
                                    }
                                    .padding(.horizontal, 32)
                                    .padding(.vertical,5)
                                    .onAppear{
                                        callNextFollow(followData: following)
                                    }
                                }
                                .onAppear{
                                    print(currentTab)
                                }
                            }
                        }
                    }
                }
            }
            // 2023.06.06 Clyde 높이 제한 추가
            .frame(height: proxy.size.height)
            .frame(maxHeight: .infinity)
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
        followVM.followGet(username: username, page: 1, tab: currentTab.rawValue)
    }
    
    func callNextFollow(followData : ProfileModel){
        if followVM.followModel?.results.isEmpty == false && followVM.followModel?.next != nil && followData.username == followVM.followModel?.results.last?.username{
            self.currentPage += 1
            followVM.followGet(username: username, page: currentPage, tab: currentTab.rawValue)
        }
    }
}

