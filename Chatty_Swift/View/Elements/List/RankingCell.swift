//
//  RankingCell.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/04/19.
//

import SwiftUI
import Combine
import Kingfisher

struct RankingCell: View {
    @EnvironmentObject var chattyVM: ChattyVM
    
    @State var ranking : Ranking
    @State private var valueSubscriber: AnyCancellable?
    
    @State var rank : Int
    
    var body: some View {
        ZStack{
            Color.white
            HStack(spacing: 24){
                Text("\(rank)")
                    .font(Font.system(size: 14, weight: .semibold))
                    .foregroundColor(Color("Pink Main"))
                KFImage(URL(string: "\(self.ranking.profileImage)"))
                    .resizable()
                    .clipShape(Circle())
                    .scaledToFill()
                    .frame(width: 48, height: 48)
                    .clipped()
                Text("\(self.ranking.profileName)")
                    .font(Font.system(size: 14, weight: .bold))
                Spacer()
                Text("\(self.ranking.questionCount.abbreviateNumber())개")
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
        .onTapGesture {
            chattyVM.username = self.ranking.username
            print("Ranking Cell : ",chattyVM.username)
            chattyVM.profilePressed.send()
        }
    }
}

struct RankingCell_Previews: PreviewProvider {
    static var previews: some View {
        RankingCell(ranking: Ranking(username:"김개똥", profileName: "김개똥", profileImage: "https://newprofilepic2.photo-cdn.net//assets/images/article/profile.jpg", questionCount: 10000), rank: 3)
    }
}
