//
//  CardView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/02/25.
//

import SwiftUI

struct CardView: View {
    
    @State var questionData : ResultDetail
    
    @State var username : String = ""
    @State var profile_image : String = ""
    
    @State var content : String = ""
    @State var answer : String = ""
    
    var body: some View {
        ZStack {
            Color.white
            VStack(alignment: .leading, spacing: 16) {
                HStack{
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 0){
                            Text("To @")
                                .font(.system(size:12))
                            Text("\(username)")
                                .font(.system(size:12, weight: .bold))
                        }
                        .foregroundColor(Color("MainPrimary"))
                        Text("\(questionData.content)")
                    }
                    Spacer()
                }
                HStack(alignment: .top){
                    Image(systemName:"arrow.turn.down.right")
                        .foregroundColor(Color("MainPrimary"))
                        .fontWeight(.bold)
                        .frame(width: 25, height: 25)
                    AsyncImage(url: URL(string:
                                            "\(profile_image)")) {
                        image in image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48)
                            .clipShape(Circle())
                    } placeholder: {
                    }
                    VStack(alignment: .leading) {
                        HStack(alignment: .center){
                            Text("\(username)")
                                .font(.system(size:16, weight: .bold))
                                .padding(.bottom, 0.5)
                            Text("@...")
                                .font(.system(size:12, weight: .light))
                                .foregroundColor(Color.gray)
                            Text("\(elapsedtime(time: questionData.createdDate))")
                                .font(.system(size:12, weight: .light))
                                .foregroundColor(Color.gray)
                        }
                        Text("\(questionData.answerContent)")
                            .font(.system(size:16, weight: .none))
                    }
                }
                HStack(alignment: .center, spacing: 0){
                    Spacer()
                    Image(systemName: "heart")
                        .font(.system(size:14, weight: .regular))
                    Text("3")
                        .font(.system(size:14, weight: .regular))
                    Spacer()
                    Image(systemName: "bookmark")
                        .font(.system(size:14, weight: .regular))
                    Spacer()
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size:14, weight: .regular))
                    Spacer()
                }
            }
            .padding(16)
        }
        .frame(width:380, height: 200)
        .mask(RoundedRectangle(cornerRadius: 20))
        .shadow(
            color: Color("Main Background"),
            radius: CGFloat(20)
        )
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(questionData: ResultDetail(pk: 2, nickname: "안녕안녕", content: "안녕안녕", createdDate: "안녕안녕", answerContent: "안녕안녕"), username: "안녕안녕", profile_image: "안녕안녕")
    }
}
