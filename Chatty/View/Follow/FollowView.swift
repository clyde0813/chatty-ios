import SwiftUI
import Kingfisher

enum followTab {
    case follow,following
    
}

struct FollowView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var username : String
    
    @State var currentTab : followTab = .follow
    @State var tabName = ""
    
    @StateObject var followVM = FollowVM()
    
    @State var currentPage = 1
    
    @State var isFollowEmpty = false
    
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
            if currentTab == .follow {
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
                    currentTab = .follow
                    tabName = "followers"
                    self.initFollowView()
                }){
                    if currentTab == .follow {
                        VStack(alignment: .center, spacing: 0){
                            Text("팔로우")
                                .font(Font.system(size: 16, weight: .bold))
                                .accentColor(.black)
                                .padding(.bottom, 9)
                            Rectangle()
                                .fill(Color("Main Secondary"))
                                .frame(width: 50, height: 3)
                        }
                    } else {
                        VStack{
                            Text("팔로우")
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
                    tabName = "followings"
                    self.initFollowView()
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
                LazyVStack(spacing: 16){
                    if let followList = followVM.followModel?.results {
                        if currentTab == .follow {
                            ForEach(followList,id:\.userID) { follow in
                                HStack(spacing: 24){
                                    KFImage(URL(string: follow.profileImage ))
                                        .resizable()
                                        .clipShape(Circle())
                                        .scaledToFill()
                                        .frame(width: 48, height: 48)
                                        .clipped()
                                    Text("\(follow.profile_name)")
                                        .font(Font.system(size: 14, weight: .bold))
                                    Spacer()
                                    if !follow.followState{
                                        Button {
                                            print("!!")
                                        } label: {
                                            Text("맞팔로우")
                                                .font(Font.system(size: 14, weight: .bold))
                                                .foregroundColor(Color.white)
                                                .padding(.vertical, 8)
                                                .padding(.horizontal,10)
                                                .background(Color("Main Secondary"))
                                                .cornerRadius(16)
                                        }
                                    }else{
                                        Button {
                                            print("!!")
                                        } label: {
                                            Text("팔로잉")
                                                .font(Font.system(size: 14, weight: .bold))
                                                .foregroundColor(Color.white)
                                                .padding(.vertical, 8)
                                                .padding(.horizontal,12)
                                                .background(Color("Grey300"))
                                                .cornerRadius(16)
                                        }
                                    }
                                }
                                .padding(.horizontal, 32)
                                .padding(.vertical,5)
                            }
                        }
                        else if currentTab == .following {
                            ForEach(followList,id:\.userID) { follow in
                                HStack(spacing: 24){
                                    KFImage(URL(string: follow.profileImage ))
                                        .resizable()
                                        .clipShape(Circle())
                                        .scaledToFill()
                                        .frame(width: 48, height: 48)
                                        .clipped()
                                    Text("\(follow.profile_name)")
                                        .font(Font.system(size: 14, weight: .bold))
                                    Spacer()
                                    if !follow.followState{
                                        Button {
                                            print("!!")
                                        } label: {
                                            Text("팔로잉")
                                                .font(Font.system(size: 14, weight: .bold))
                                                .foregroundColor(Color.white)
                                                .padding(.vertical, 8)
                                                .padding(.horizontal,15)
                                                .background(Color("Grey300"))
                                                .cornerRadius(16)
                                        }
                                    }else{
                                        Button {
                                            print("!!")
                                        } label: {
                                            Text("팔로잉")
                                                .font(Font.system(size: 14, weight: .bold))
                                                .foregroundColor(Color.white)
                                                .padding(.vertical, 8)
                                                .padding(.horizontal,15)
                                                .background(Color("Main Secondary"))
                                                .cornerRadius(16)
                                        }
                                    }
                                }
                                .padding(.horizontal, 32)
                                .padding(.vertical,5)
                            }
                        }
                    }
                    else{
                        VStack{
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        if isFollowEmpty{
                            VStack{
                                Text("헤헤 병신~ 팔로우 팔로잉 없데여 ㅋㅋ")
                            }
                        }
                    }
                }
            }
            // 2023.06.06 Clyde 높이 제한 추가
            .frame(height: proxy.size.height)
            .frame(maxHeight: .infinity)
        }
        .onReceive(followVM.isEmptyList){
            isFollowEmpty = true
        }
    }
        
}

//MARK: - Methods
extension FollowView {
    func initFollowView(){
        followVM.followModel = nil
        followVM.followGet(username: username, page: 1, tab: tabName)
    }
}

struct FollowView_Previews: PreviewProvider {
    static var previews: some View {
        FollowView(username: .constant("test11"))
    }
}
