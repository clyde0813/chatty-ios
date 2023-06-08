//
//  CardView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/02/25.
//

import SwiftUI
import Kingfisher

struct ResponsedCard: View {
    @EnvironmentObject var chattyVM: ChattyVM
    
    @State var width : CGFloat = 0.0
    
    @State var questiondata : ResultDetail
    
    var body: some View {
        ZStack{
            Color.white
            VStack(alignment: .leading, spacing: 0){
                HStack(spacing: 0){
                    if questiondata.author != nil {
                        HStack{
                            KFImage(URL(string:"\(questiondata.author?.profileImage ?? "" )"))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 45, height: 45)
                                .clipShape(Circle())
                                .overlay(Circle()
                                    .stroke(Color.white, lineWidth: 3))
                                .clipped()
                                .padding(.trailing, 8)
                            VStack(alignment: .leading, spacing: 0){
                                HStack(spacing: 4){
                                    Text(questiondata.author?.profileName ?? "")
                                        .font(Font.system(size: 16, weight: .bold))
                                    Text("•")
                                        .font(Font.system(size: 12, weight: .semibold))
                                        .foregroundColor(Color.gray)
                                    Text("\(elapsedtime(time: questiondata.createdDate))")
                                        .font(Font.system(size: 12, weight: .semibold))
                                        .foregroundColor(Color.gray)
                                }
                                .padding(.bottom, 8)
                                Text(questiondata.content)
                                    .font(Font.system(size: 16, weight: .none))
                                    .padding(.trailing, 5)
                            }
                        }
                    } else {
                        HStack(spacing: 0){
                            Text("From @")
                                .font(.system(size:12))
                            Text("익명")
                                .font(.system(size:12, weight: .bold))
                        }
                        .foregroundColor(Color("Main Primary"))
                    }
                    Spacer()
                    Button(action : {
                        chattyVM.username = questiondata.profile.username
                        chattyVM.profile_name = questiondata.profile.profileName
                        chattyVM.profile_image = questiondata.profile.profileImage
                        chattyVM.background_image = questiondata.profile.backgroundImage
                        chattyVM.questiondata = self.questiondata
                        chattyVM.questionOptionStatus = true
                    }){
                        ZStack{
                            Image(systemName: "ellipsis")
                                .foregroundColor(.black)
                                .rotationEffect(.degrees(-90))
                                .font(Font.system(size: 16, weight: .bold))
                        }
                        .frame(width: 20, height: 20)
                    }
                }
                .padding(.bottom, 4)
                //질문 내용
                if questiondata.author == nil {
                    Text("\(questiondata.content)")
                        .font(Font.system(size: 16, weight: .none))
                        .padding(.bottom, 16)
                        .padding(.trailing, 15)
                }
                
                //딥변 영역
                HStack(alignment: .top, spacing: 0){
                    //답변 표현 화살표
                    Image(systemName: "arrow.turn.down.right")
                        .foregroundColor(Color("Main Primary"))
                        .fontWeight(.semibold)
                        .font(Font.system(size: 16, weight: .bold))
                        .padding([.top, .trailing], 4)
                    //Profile 사진
                    KFImage(URL(string:"\(questiondata.profile.profileImage)"))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                        .overlay(Circle()
                            .stroke(Color.white, lineWidth: 3))
                        .clipped()
                        .padding(.trailing, 8)
                    VStack(alignment: .leading, spacing: 0){
                        HStack(spacing: 4){
                            Text("\(questiondata.profile.profileName)")
                                .font(Font.system(size: 16, weight: .bold))
                            Text("•")
                                .font(Font.system(size: 12, weight: .semibold))
                                .foregroundColor(Color.gray)
                            Text("\(elapsedtime(time: questiondata.createdDate))")
                                .font(Font.system(size: 12, weight: .semibold))
                                .foregroundColor(Color.gray)
                        }
                        .padding(.bottom, 8)
                        Text("\(questiondata.answerContent ?? "")")
                            .font(Font.system(size: 16, weight: .none))
                            .padding(.trailing, 5)
                    }
                }
                .padding(.top, questiondata.author == nil ? 0 : 21)
//                .padding(.bottom, 16)
//                HStack(spacing: 0){
//                    Image(systemName: "heart")
//                        .fontWeight(.semibold)
//                        .font(Font.system(size: 16, weight: .bold))
//                        .frame(width: (width-32) / 3)
//                    Image(systemName: "bookmark")
//                        .fontWeight(.semibold)
//                        .font(Font.system(size: 16, weight: .bold))
//                        .frame(width: (width-32) / 3)
//                    Image(systemName: "square.and.arrow.up")
//                        .fontWeight(.semibold)
//                        .font(Font.system(size: 16, weight: .bold))
//                        .frame(width: (width-32) / 3)
//                }
            }
            .padding([.leading, .trailing, .bottom], 16)
            .padding(.top, 12)
        }
        .frame(width: width)
        .frame(minHeight: 0)
        .fixedSize(horizontal: false, vertical: true)
        .mask(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color("Shadow Card"), radius: 3, x: 0, y: 7)
    }
}
//
//struct ResponsedCard_Previews: PreviewProvider {
//    static var previews: some View {
//        ResponsedCard(width: 320, questiondata: ResultDetail(pk: 2, content: "Question Content", createdDate: "2023-03-26T22:01:42.000000", answerContent: "Answer Content"), username: "Username", profile_name: "김봉팔", profile_image: "https://chatty-s3-dev.s3.ap-northeast-2.amazonaws.com/default.png")
//    }
//}
