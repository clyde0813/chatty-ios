
import SwiftUI
import Kingfisher

struct BlockedUsersView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewmodel = BlockUserVM()
    
    
    var body: some View {
        VStack{
            navView
                .background(Rectangle()
                    .fill(Color.white)
                    .shadow(color: Color("Shadow Button"), radius: 3, x: 0, y: 6)
                )
            
            ScrollView(showsIndicators: false) {
                LazyVStack{
                    ForEach(viewmodel.blockUserList?.results ?? [], id:\.username) { user in
                        ZStack{
                            Color.white
                            HStack{
                                NavigationLink(value: myPageStack.profileView(user.username)) {
                                    UserCell(profileImage: user.profileImage, profileName: user.profile_name, username: user.username)
                                }
                                Spacer()
                                Button(action: {
                                    viewmodel.deleteUserBlock(username: user.username)
                                }){
                                    Text("차단해제")
                                        .font(.system(size:14, weight: .bold))
                                        .frame(width: 60, height: 18)
                                        .foregroundColor(Color.white)
                                        .padding(.vertical,10)
                                        .padding(.horizontal)
                                        .background(
                                            Capsule()
                                                .fill(Color("Grey300"))
                                        )
                                }
                            }
                            .padding([.leading, .trailing], 16)
                            .padding([.top, .bottom], 12)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 72)
                        .mask(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: Color("Shadow Card"), radius: 3, x: 0, y: 7)
                        .padding([.leading, .trailing], 20)
                        
                    }
                }
            }
            Spacer()
                .toolbar(.hidden)
        }
        .onAppear{
            viewmodel.blockedUserListGet()
        }
    }
}


extension BlockedUsersView {
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
            Spacer()
            Text("차단유저목록")
                .font(.system(size: 18))
                .fontWeight(.medium)
                .foregroundColor(.black)
            Spacer()
            Button(action:{
                dismiss()
            }){
                Image(systemName: "arrow.left")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            .opacity(0)
        }
        .padding(.horizontal,24)
        .padding(.vertical,14)
    }
}
