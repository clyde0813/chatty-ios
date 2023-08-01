import SwiftUI
import Kingfisher

//SearchView & BlockUserList에서 사용될 셀
struct UserCell: View {
    let profileImage : String
    let profileName : String
    let username : String
    
    init(profileImage: String, profileName: String, username: String) {
        self.profileImage = profileImage
        self.profileName = profileName
        self.username = username
    }
    var body: some View {
        HStack(spacing: 12){
            KFImage(URL(string:profileImage))
                .resizable()
                .scaledToFill()
                .frame(width: 48, height: 48)
                .clipShape(Circle())
                .clipped()
                .padding(.trailing, 8)
            VStack(alignment: .leading, spacing: 4){
                Text(profileName)
                    .font(Font.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.black)
                Text("@\(username)")
                    .font(Font.system(size: 11, weight: .light))
                    .foregroundColor(Color("Text Light Secondary"))
            }
        }
    }
}

struct UserCell_Previews: PreviewProvider {
    static var previews: some View {
        UserCell(profileImage: "", profileName: "test111", username: "test111")
    }
}
