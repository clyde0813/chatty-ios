
import SwiftUI
import Kingfisher

struct BlockedUsersView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var profileVM : ProfileVM
    
    var body: some View {
        VStack{
            navView
                .background(Rectangle()
                    .fill(Color.white)
                    .shadow(color: Color("Shadow Button"), radius: 3, x: 0, y: 6)
                )
            
            ScrollView(showsIndicators: false) {
                LazyVStack{
                    if let refuseList = profileVM.blockedUserModel?.results {
                        ForEach(refuseList, id:\.username) { data in
                            ZStack{
                                Color.white
                                HStack{
//                                    NavigationLink {
//                                        ProfileView(username: .constant(data.username) )
//                                    } label: {
//                                        HStack(spacing: 12){
//                                            KFImage(URL(string:data.profileImage))
//                                                .resizable()
//                                                .scaledToFill()
//                                                .frame(width: 48, height: 48)
//                                                .clipShape(Circle())
//                                                .clipped()
//                                                .padding(.trailing, 8)
//                                            VStack(alignment: .leading, spacing: 4){
//                                                Text(data.profile_name)
//                                                    .font(Font.system(size: 14, weight: .semibold))
//                                                    .foregroundColor(Color.black)
//                                                Text("@\(data.username)")
//                                                    .font(Font.system(size: 11, weight: .light))
//                                                    .foregroundColor(Color("Text Light Secondary"))
//                                            }
//                                        }
//                                    }
                                    Spacer()
                                    Button(action: {
                                        profileVM.DeleteUserBlock(username: data.username)
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
//                            .onAppear{
//                                callNextRseult(data: data)
//                            }
                        }
                    }
                    
                }
            }
            Spacer()
                .toolbar(.hidden)
        }
        .onAppear{
            profileVM.blockedUserListGet()
            
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
//struct RefuseListView_Previews: PreviewProvider {
//    static var previews: some View {
//        BlockedUsersView()
//    }
//}
