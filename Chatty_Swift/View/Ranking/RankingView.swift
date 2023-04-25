//
//  RankingView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/02/23.
//

import SwiftUI
import Kingfisher

struct RankingView: View {
    @EnvironmentObject var chattyVM: ChattyVM
    
    @State var offset: CGFloat = 0
    
    @State var rankingList = [Ranking]()
        
    var body: some View {
        GeometryReader{ proxy in
            if self.rankingList.isEmpty {
                ZStack{
                    Color.white
                    ProgressView("불러오는중...")
                        .foregroundColor(Color.black)
                }
                .ignoresSafeArea(.all)
            } else if self.rankingList.count < 4 {
                ZStack{
                    Color.white
                    Text("아직 이용자가 부족합니다!")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color("Pink Main"))
                }
                .ignoresSafeArea(.all)
            } else {
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack(spacing: 0){
                        GeometryReader { proxy -> AnyView in

                            // Sticky Header...
                            let minY = proxy.frame(in: .global).minY
                            DispatchQueue.main.async {

                                self.offset = minY
                            }

                            return AnyView(
                                ZStack{
                                    LinearGradient(gradient: Gradient(colors: [Color("MainGradient1"), Color("MainGradient2"),Color("MainGradient3")]),
                                                    startPoint: .trailing, endPoint: .leading)
                                        .scaledToFill()
                                        .frame(
                                            width: proxy.size.width,
                                            height: minY > 0 ? 430 + minY : 430, alignment: .center
                                        )
                                    VStack(spacing: 24){
//                                        RoundedRectangle(cornerRadius: 50)
//                                            .fill(Color.white)
//                                            .frame(height: 50)
//                                            .padding(.top, 40)
//                                            .padding([.leading, .trailing], 16)
//                                            .padding(.bottom, -45)
                                        Text("Chatty")
                                            .font(.system(size: 26, weight: .heavy))
                                            .foregroundColor(Color.white)
                                            .padding(.top, 40)
                                            .padding(.bottom, -45)
                                        HStack(spacing: 0){
                                            VStack{
                                                ZStack(){
                                                    KFImage(URL(string: "\(rankingList[1].profileImage)"))
                                                        .resizable()
                                                        .clipShape(Circle())
                                                        .scaledToFill()
                                                        .frame(width: 80, height: 80)
                                                        .clipped()
                                                        .background(
                                                            Circle()
                                                                .fill(.shadow(.inner(radius: 10)))
                                                        )
                                                    KFImage(URL(string: "https://chatty-s3-dev.s3.ap-northeast-2.amazonaws.com/resource/ranking/ranking-2nd.png"))
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 24, height: 37)
                                                        .clipped()
                                                        .offset(x: 25, y: -27)
                                                }
                                                Text("\(rankingList[1].profileName)")
                                                    .font(.system(size: 16))
                                                    .fontWeight(.bold)
                                                    .foregroundColor(Color(.white))
                                                Text("\(rankingList[1].questionCount)개")
                                                    .font(.system(size: 12))
                                                    .fontWeight(.bold)
                                                    .frame(width: 80, height: 28)
                                                    .foregroundColor(Color(.white))
                                                    .background(Color("Grey300").opacity(0.2))
                                                    .cornerRadius(16)
                                            }
                                            .padding(.top, 100)
                                            .padding(.leading, 32)
                                            .frame(width:proxy.size.width*0.3, height: 200)
                                            .onTapGesture {
                                                chattyVM.username = rankingList[1].username
                                                chattyVM.profilePressed.send()
                                            }
                                            VStack{
                                                ZStack{
                                                    KFImage(URL(string: "\(rankingList[0].profileImage)"))
                                                        .resizable()
                                                        .clipShape(Circle())
                                                        .scaledToFill()
                                                        .frame(width: 110, height: 110)
                                                        .clipped()
                                                    KFImage(URL(string: "https://chatty-s3-dev.s3.ap-northeast-2.amazonaws.com/resource/ranking/ranking-1st.png"))
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 24, height: 37)
                                                        .clipped()
                                                        .offset(x: 35, y: -37)
                                                }
                                                Text("\(rankingList[0].profileName)")
                                                    .font(.system(size: 16))
                                                    .fontWeight(.bold)
                                                    .foregroundColor(Color(.white))
                                                Text("\(rankingList[0].questionCount)개")
                                                    .font(.system(size: 12))
                                                    .fontWeight(.bold)
                                                    .frame(width: 80, height: 28)
                                                    .foregroundColor(Color(.white))
                                                    .background(Color("Grey300").opacity(0.2))
                                                    .cornerRadius(16)
                                            }
                                            .frame(width:proxy.size.width*0.4, height: 270)
                                            .onTapGesture {
                                                chattyVM.username = rankingList[0].username
                                                chattyVM.profilePressed.send()
                                            }
                                            VStack{
                                                ZStack{
                                                    KFImage(URL(string: "\(rankingList[2].profileImage)"))
                                                        .resizable()
                                                        .clipShape(Circle())
                                                        .scaledToFill()
                                                        .frame(width: 80, height: 80)
                                                        .clipped()
                                                    KFImage(URL(string: "https://chatty-s3-dev.s3.ap-northeast-2.amazonaws.com/resource/ranking/ranking-3rd.png"))
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 24, height: 37)
                                                        .clipped()
                                                        .offset(x: 25, y: -27)
                                                }
                                                Text("\(rankingList[2].profileName)")
                                                    .font(.system(size: 16))
                                                    .fontWeight(.bold)
                                                    .foregroundColor(Color(.white))
                                                Text("\(rankingList[2].questionCount)개")
                                                    .font(.system(size: 12))
                                                    .fontWeight(.bold)
                                                    .frame(width: 80, height: 28)
                                                    .foregroundColor(Color(.white))
                                                    .background(Color("Grey300").opacity(0.2))
                                                    .cornerRadius(16)
                                            }
                                            .padding(.top, 100)
                                            .padding(.trailing, 32)
                                            .frame(width:proxy.size.width*0.3, height: 200)
                                            .onTapGesture {
                                                chattyVM.username = rankingList[2].username
                                                chattyVM.profilePressed.send()
                                            }
                                        }
                                    }
                                    .padding(.bottom, 30)
                                }
                                    .clipped()
                                // Stretchy Header...
                                    .frame(height: minY > 0 ? 430 + minY : nil)
                                    .offset(y: minY > 0 ? -minY : -minY < 0 ? 0 : -minY - 0)
                            )}
                        .frame(height: 380)
                        .zIndex(0)
                        ZStack(alignment: .top){
                            Color.white
                                .mask(RoundedCornersShape(corners: [.topLeft, .topRight], radius: 20))
                            VStack(spacing: 0){
                                ForEach(0..<self.rankingList.count - 3, id: \.self) {
                                    RankingCell(ranking: self.rankingList[$0+3], rank: $0+4)
                                }
                            }
                            .padding([.top, .bottom], 24)
                        }
                        .frame(minHeight: proxy.size.height,
                               maxHeight: .infinity
                               )
                        .zIndex(1)
                    }
                    .frame(width: proxy.size.width)
                })
                .ignoresSafeArea(.all)
            }
        }
        .onAppear{
            self.rankingList.removeAll()
            chattyVM.rankingGet()
        }
        .onReceive(chattyVM.$rankingModel){ data in
            self.rankingList += data?.ranking ?? []
        }
    }
}

struct RankingView_Previews: PreviewProvider {
    static var previews: some View {
        RankingView().environmentObject(ChattyVM())
    }
}

