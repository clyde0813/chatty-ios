//
//  RejectedCardView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/04/09.
//

import SwiftUI

struct RefusedCard: View {
    @EnvironmentObject var chattyVM: ChattyVM

    @State var width : CGFloat = 0.0
    
    @State var questiondata : ResultDetail
    
    @State var username : String = ""
    
    @State var profile_name : String = ""
    
    @State var profile_image : String = ""
    
    @State var background_image : String = ""
    
    var body: some View {
        ZStack{
            Color.white
            VStack(alignment: .leading, spacing: 0){
                HStack{
                    HStack {
                        HStack(spacing: 0){
                            Text("From @")
                                .font(.system(size:12))
                            Text("익명")
                                .font(.system(size:12, weight: .bold))
                                .padding(.trailing, 8)
                            Text("•")
                                .font(Font.system(size: 12, weight: .semibold))
                                .foregroundColor(Color.gray)
                                .padding(.trailing, 8)
                            Text("\(elapsedtime(time: questiondata.createdDate))")
                                .font(Font.system(size: 12, weight: .semibold))
                                .foregroundColor(Color.gray)
                        }
                        .foregroundColor(Color("Main Primary"))
                        Spacer()
                        Button(action : {
                            chattyVM.username = self.username
                            chattyVM.profile_name = self.profile_name
                            chattyVM.profile_image = self.profile_image
                            chattyVM.background_image = self.background_image
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
                }
                .padding(.bottom, 4)
                Text("\(questiondata.content)")
                    .font(Font.system(size: 16, weight: .none))
                    .padding(.trailing, 15)
            }
            .padding(16)
        }
        .frame(width: width)
        .fixedSize(horizontal: false, vertical: true)
        .mask(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color("Shadow Card"), radius: 3, x: 0, y: 7)
    }
}

struct RefusedCard_Previews: PreviewProvider {
    static var previews: some View {
        RefusedCard(questiondata: ResultDetail(pk: 2, content: "야 나랑 놀자 밤늦게까지 함께 손뼉 치면서 나랑 마셔 너와 나의 몸이 녹아 내리면 나랑 걷자 저 멀리까지가다 지쳐 누우면 나랑 자자 두 눈 꼭 감고 나랑 입 맞추자", createdDate: "2023-03-26T22:01:42.000000", answerContent: "안녕안녕"))
    }
}
