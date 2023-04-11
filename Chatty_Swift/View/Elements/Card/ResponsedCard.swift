//
//  CardView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/02/25.
//

import SwiftUI

struct ResponsedCard: View {
    @State var width : CGFloat = 0.0
    @State var questionData : ResultDetail
    
    @State var username : String = ""
    @State var profile_image : String = ""
    
    var body: some View {
        ZStack{
            Color.white
            VStack(alignment: .leading, spacing: 0){
                HStack{
                    HStack(spacing: 0){
                        Text("From @")
                            .font(.system(size:12))
                        Text("익명")
                            .font(.system(size:12, weight: .bold))
                    }
                    .foregroundColor(Color("MainPrimary"))
                    Spacer()
                    Image(systemName: "ellipsis")
                        .foregroundColor(.black)
                        .rotationEffect(.degrees(-90))
                        .font(Font.system(size: 16, weight: .bold))
                }
                .padding(.bottom, 4)
                //질문 내용
                Text("\(questionData.content)")
                    .font(Font.system(size: 16, weight: .none))
                    .padding(.bottom, 16)
                    .padding(.trailing, 15)
                //딥변 영역
                HStack(alignment: .top, spacing: 0){
                    //답변 표현 화살표
                    Image(systemName: "arrow.turn.down.right")
                        .foregroundColor(Color("MainPrimary"))
                        .fontWeight(.semibold)
                        .font(Font.system(size: 16, weight: .bold))
                        .padding([.top, .trailing], 4)
                    //Profile 사진
                    AsyncImage(url: URL(string:
                                            "\(profile_image)")) {
                        image in image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 45, height: 45)
                            .clipShape(Circle())
                            .overlay(Circle()
                            .stroke(Color.white, lineWidth: 3))
                            .clipped()
                    } placeholder: {
                    }
                    .padding(.trailing, 8)
                    VStack(alignment: .leading, spacing: 0){
                        HStack(spacing: 4){
                            Text("\(username)")
                                .font(Font.system(size: 16, weight: .bold))
                            Text("...")
                                .font(Font.system(size: 12, weight: .semibold))
                                .foregroundColor(Color.gray)
                            Text("•")
                                .font(Font.system(size: 12, weight: .semibold))
                                .foregroundColor(Color.gray)
                            Text("\(elapsedtime(time: questionData.createdDate))")
                                .font(Font.system(size: 12, weight: .semibold))
                                .foregroundColor(Color.gray)
                        }
                        .padding(.bottom, 8)
                        Text("\(questionData.answerContent ?? "")")
                            .font(Font.system(size: 16, weight: .none))
                    }
                }
                .padding(.bottom, 16)
                HStack(spacing: 0){
                    Image(systemName: "heart")
                        .fontWeight(.semibold)
                        .font(Font.system(size: 16, weight: .bold))
                        .frame(width: (width-32) / 3)
                    Image(systemName: "bookmark")
                        .fontWeight(.semibold)
                        .font(Font.system(size: 16, weight: .bold))
                        .frame(width: (width-32) / 3)
                    Image(systemName: "square.and.arrow.up")
                        .fontWeight(.semibold)
                        .font(Font.system(size: 16, weight: .bold))
                        .frame(width: (width-32) / 3)
                }
            }
            .padding(16)
        }
        .frame(width: width)
        .frame(minHeight: 170)
        .fixedSize(horizontal: false, vertical: true)
        .mask(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color("Button Grey"), radius: 3, x: 0, y: 1)
    }
}

struct ResponsedCard_Previews: PreviewProvider {
    static var previews: some View {
        ResponsedCard(width: 320, questionData: ResultDetail(pk: 2, nickname: "Questioner Name", content: "Question Content", createdDate: "2023-03-26T22:01:42.000000", answerContent: "Answer Content"), username: "Username", profile_image: "https://chatty-s3-dev.s3.ap-northeast-2.amazonaws.com/default.png")
    }
}
