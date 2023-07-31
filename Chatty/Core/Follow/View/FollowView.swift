import SwiftUI
import Kingfisher

enum followTab :String {
    case follower = "followers"
    case following = "followings"
}

struct FollowView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var followVM = FollowVM()
    
    let username : String
    
    @State var currentTab : followTab
    
    @State var currentPage = 1

    @State var isProgressBar = true
    
    @State var optionShow = false
    
    init(username : String, followTab : followTab){
        self.username = username
        self._currentTab = State(wrappedValue: followTab)
    }

    
    
    var body: some View {
        ZStack{
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
            
            .blur(radius: optionShow ? 2 : 0)
            //Blur 처리
            if optionShow {
                BlurView()
                    .ignoresSafeArea()
                    .onTapGesture {
                        optionShow.toggle()
                    }
                    .background(Color("Background Overlay"))
                    .opacity(0.7)
                    .toolbar(.hidden ,for: .tabBar)
            }
            
        }
        .onAppear{
            followVM.getFollow(username: username,currentTab: currentTab)
        }
        .onDisappear{
            followVM.reset()
            followVM.currentPage = nil
            followVM.cancel()
        }
        .onChange(of: currentTab, perform: { newValue in
            followVM.reset()
            followVM.currentPage = 1
            followVM.getFollow(username: username, currentTab: currentTab)
        })
        .navigationBarBackButtonHidden(true)
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
                    currentTab = .follower
                }){
                    if currentTab == .follower {
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
                    currentTab = .following
                }){
                    if currentTab == .following {
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
                if followVM.followlist == nil {
                    VStack{
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
                else {
                    //내 팔로우 뷰 일 경우
                    if username == KeyChain.read(key: "username"){
                        if currentTab == .follower {
                            if let followList = followVM.followlist??.results {
                                LazyVStack(spacing: 0){
                                    ForEach(followList, id:\.username) { follower in
                                        HStack(spacing: 24){
                                            HStack{
                                                //profile image & ID + Profile Name Area
                                                NavigationLink(value: StackPath.profileView(follower.username)) {
                                                    HStack(spacing: 6){
                                                        KFImage(URL(string:follower.profileImage))
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 48, height: 48)
                                                            .clipShape(Circle())
                                                            .clipped()
                                                            .padding(.trailing, 8)

                                                        Text(follower.profile_name)
                                                            .font(Font.system(size: 14, weight: .semibold))
                                                            .foregroundColor(Color.black)
                                                            .lineLimit(1)
                                                            .truncationMode(.tail)

                                                        //맞팔로우한 사람일때
                                                        if follower.followState {
                                                            Text("•")
                                                                .font(Font.system(size: 14, weight: .bold))
                                                            Text("맞팔로워")
                                                                .font(Font.system(size: 14, weight: .bold))
                                                                .foregroundColor(Color("Main Secondary"))
                                                                .lineLimit(1)
                                                                .truncationMode(.tail)
                                                        }
                                                    }
                                                }
                                            }
                                            Spacer()
                                            if follower.username == KeyChain.read(key: "username")! {
                                                //다른사람의 팔로우,팔로워리스트 볼떄 본인의프로필은 뭐가 안나와야하니 아무것도처리안해둠
                                            }
                                            
                                            Button {
                                                followVM.profileModel = follower
                                                optionShow.toggle()
                                            } label: {
                                                Text("삭제")
                                                    .font(Font.system(size: 14, weight: .bold))
                                                    .foregroundColor(Color("Orange Main"))
                                                    .frame(width:80, height: 30)
                                                    .padding(.vertical,4)
                                                    .background(
                                                        Capsule()
                                                            .strokeBorder(Color("Orange Main"), lineWidth: 1)
                                                    )
                                            }
                                            
                                        }
                                        .padding([.leading, .trailing], 32)
                                        .padding([.top, .bottom], 12)
                                        .onAppear{
                                            followVM.callNextFollow(username:username, followData: follower, currentTab: currentTab)
                                        }
                                    }
                                }
                            }
                        }
                        else if currentTab == .following{
                            if let followList = followVM.followlist??.results{
                                LazyVStack(spacing: 0){
                                    ForEach(followList, id:\.username) { following in
                                        HStack(spacing: 24){
                                            HStack{
                                                //profile image & ID + Profile Name Area
                                                NavigationLink(value: StackPath.profileView(following.username)) {
                                                    HStack(spacing: 6){
                                                        KFImage(URL(string:following.profileImage))
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 48, height: 48)
                                                            .clipShape(Circle())
                                                            .clipped()
                                                            .padding(.trailing, 8)

                                                        Text(following.profile_name)
                                                            .font(Font.system(size: 14, weight: .semibold))
                                                            .foregroundColor(Color.black)
                                                            .lineLimit(1)
                                                            .truncationMode(.tail)
                                                    }
                                                }
                                            }
                                            Spacer()
                                            
                                            if following.followState {
                                                Button {
                                                    followVM.followPost(username: following.username)
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
                                                    followVM.followPost(username: following.username)
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
                                            followVM.callNextFollow(username:username, followData: following, currentTab: currentTab)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    //다른사람의 팔로우 뷰 일 경우
                    else {
                        if currentTab == .follower {
                            if let followList = followVM.followlist??.results {
                                LazyVStack(spacing: 0){
                                    ForEach(followList, id:\.username) { follower in
                                        HStack(spacing: 24){
                                            HStack{
                                                //profile image & ID + Profile Name Area
                                                NavigationLink(value: StackPath.profileView(follower.username)) {
                                                    HStack(spacing: 6){
                                                        KFImage(URL(string:follower.profileImage))
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 48, height: 48)
                                                            .clipShape(Circle())
                                                            .clipped()
                                                            .padding(.trailing, 8)

                                                        Text(follower.profile_name)
                                                            .font(Font.system(size: 14, weight: .semibold))
                                                            .foregroundColor(Color.black)
                                                            .lineLimit(1)
                                                            .truncationMode(.tail)
                                                        //맞팔로우한 사람일때
                                                        if follower.followState && follower.username != KeyChain.read(key: "username") {
                                                            Text("•")
                                                                .font(Font.system(size: 14, weight: .bold))
                                                            Text("맞팔로워")
                                                                .font(Font.system(size: 14, weight: .bold))
                                                                .foregroundColor(Color("Main Secondary"))
                                                                .lineLimit(1)
                                                                .truncationMode(.tail)
                                                        }
                                                    }
                                                }
                                            }
                                            Spacer()
                                            if follower.username == KeyChain.read(key: "username")! {
                                                
                                            }
                                            else if follower.followState {
                                                Button {
                                                    followVM.followPost(username: follower.username)
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
                                                    followVM.followPost(username: follower.username)
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
                                            followVM.callNextFollow(username:username, followData: follower, currentTab: currentTab)
                                        }
                                    }
                                }
                            }
                        }
                        else if currentTab == .following{
                            if let followList = followVM.followlist??.results{
                                LazyVStack(spacing: 0){
                                    ForEach(followList, id:\.username) { following in
                                        HStack(spacing: 24){
                                            HStack{
                                                //profile image & ID + Profile Name Area
                                                NavigationLink(value: StackPath.profileView(following.username)) {
                                                    HStack(spacing: 6){
                                                        KFImage(URL(string:following.profileImage))
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 48, height: 48)
                                                            .clipShape(Circle())
                                                            .clipped()
                                                            .padding(.trailing, 8)
                                                        
                                                        Text(following.profile_name)
                                                            .font(Font.system(size: 14, weight: .semibold))
                                                            .foregroundColor(Color.black)
                                                            .lineLimit(1)
                                                            .truncationMode(.tail)
                                                    }
                                                }
                                            }
                                            Spacer()
                                            if following.username == KeyChain.read(key: "username")! {
                                                
                                            }
                                            else if following.followState {
                                                Button {
                                                    followVM.followPost(username: following.username)
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
                                                    followVM.followPost(username: following.username)
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
                                            followVM.callNextFollow(username:username, followData: following, currentTab: currentTab)
                                        }
                                    }
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
        .sheet(isPresented: $optionShow, onDismiss: {
            optionShow = false
        }) {
            FollowOption(profileModel: followVM.profileModel!)
                .presentationDetents([.fraction(0.35)])
        }
        
        
    }
    
}

//MARK: - Methods
//extension FollowView {
//    func initFollowView(){
//        followVM.followModel?.results.removeAll()
//        self.currentPage = 1
//        followVM.followGet(username: username, page: self.currentPage, tab: currentTab.rawValue)
//    }
//
//    func callNextFollow(followData : ProfileModel){
//        if followVM.followModel?.results.isEmpty == false && followVM.followModel?.next != nil && followData.username == followVM.followModel?.results.last?.username{
//            self.currentPage += 1
//            followVM.followGet(username: username, page: currentPage, tab: currentTab.rawValue)
//        }
//    }
//}

