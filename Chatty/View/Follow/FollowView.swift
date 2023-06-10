import SwiftUI
enum followTab {
    case follow,following
}
struct FollowView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var username : String
    
    @State var currentTab : followTab = .follow
    
    var body: some View {
        VStack{
            VStack{
                navView
                tabChangeBar
            }
            .background(Rectangle()
                .fill(Color.white)
                .shadow(color: Color("Shadow Button"), radius: 3, x: 0, y: 4)
            )
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
}


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
}

struct FollowView_Previews: PreviewProvider {
    static var previews: some View {
        FollowView(username: .constant("test11"))
    }
}
