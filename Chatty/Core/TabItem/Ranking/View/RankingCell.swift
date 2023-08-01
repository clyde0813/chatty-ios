import SwiftUI
import Combine
import Kingfisher

struct RankingCell: View {
    
    
    let ranking : Ranking?
    
    let rank : Int
    
    init(ranking: Ranking?, rank: Int){
        self.ranking = ranking
        self.rank = rank
    }

    var body: some View {
        ZStack{
            Color.white
            HStack(spacing: 24){
                Text("\(rank)")
                    .font(Font.system(size: 14, weight: .semibold))
                    .foregroundColor(Color("Pink Main"))
                KFImage(URL(string: "\(ranking?.profileImage ?? "")"))
                    .resizable()
                    .clipShape(Circle())
                    .scaledToFill()
                    .frame(width: 48, height: 48)
                    .clipped()
                Text("\(ranking?.profileName ?? "" )")
                    .font(Font.system(size: 14, weight: .bold))
                Spacer()
                Text("\(ranking?.questionCount.abbreviateNumber() ?? "1" )개")
                    .font(Font.system(size: 14, weight: .bold))
                    .foregroundColor(Color.white)
                    .frame(width:50, height: 28)
                    .background(Capsule()
                        .foregroundColor(Color("Pink Main"))
                    )
            }
            .padding([.leading, .trailing], 28)
        }
        .frame(height: 70)
    }
}

struct RankingCell_Previews: PreviewProvider {
    static var previews: some View {
        RankingCell(ranking: Ranking(username:"김개똥", profileName: "김개똥", profileImage: "https://newprofilepic2.photo-cdn.net//assets/images/article/profile.jpg", questionCount: 10000), rank: 3)
    }
}
