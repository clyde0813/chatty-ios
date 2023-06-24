
import Kingfisher
import SwiftUI

struct FollowOption: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var eventVM : ChattyEventVM
    
    var body: some View {
        ZStack{
            Color.white
            VStack(alignment: .leading, spacing: 16){
                HStack(spacing: 0){
                    Text("팔로워를 삭제하시겠어요?")
                        .font(.system(size: 20, weight: .bold))
                    Spacer()
                    Button(action: {
                        dismiss()
                    }){
                        Image(systemName: "xmark")
                            .foregroundColor(Color.black)
                            .fontWeight(.semibold)
                            .font(Font.system(size: 16, weight: .bold))
                    }
                }
                
                HStack(spacing: 6){
                    KFImage(URL(string:eventVM.followerData?.profileImage ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 48, height: 48)
                        .clipShape(Circle())
                        .clipped()
                        .padding(.trailing, 8)
                    
                    Text(eventVM.followerData?.profile_name ?? "")
                        .font(Font.system(size: 14, weight: .semibold))
                        .foregroundColor(Color.black)
                }
                
                Text("@\(eventVM.followerData?.username ?? "") 님은 회원님의 팔로워 리스트에서 삭제되며,\n팔로우가 취소된 사실은 알 수 없습니다.")
                    .lineLimit(nil)
                    .font(Font.system(size: 14, weight: .ultraLight))
                    
                Button(action:{
                    eventVM.DeleteFollower()
                    dismiss()
                }){
                    HStack(spacing: 8){
                        Text("삭제하기")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .frame(height: 60)
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity
                    )
                    .foregroundColor(.white)
                    .background(Color("Grey900"))
                    .cornerRadius(16)
                    
                }
                
                
//                .padding([.leading, .trailing, .bottom], 3)
            }
//            .clipped()
            .padding(.top,20)
            .padding(.horizontal, 20)
        }
    }
}
//
//struct FollowOption_Previews: PreviewProvider {
//    static var previews: some View {
//        FollowOption()
//    }
//}
