//
//  UnansweredCardView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/04/09.
//

import SwiftUI
import Combine

struct ArrivedCard: View {
    @EnvironmentObject var chattyVM: ChattyVM
    
    @State var width : CGFloat = 0.0

    @State var questionData : ResultDetail
        
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
                        }
                        .foregroundColor(Color("MainPrimary"))
                        Spacer()
                        Image(systemName: "ellipsis")
                            .foregroundColor(.black)
                            .rotationEffect(.degrees(-90))
                            .font(Font.system(size: 16, weight: .bold))
                    }
                }
                .padding(.bottom, 4)
                Text("\(questionData.content)")
                    .font(Font.system(size: 16, weight: .none))
                    .padding(.bottom, 16)
                    .padding(.trailing, 15)
                HStack(spacing: 0){
                    Button(action:{
                        chattyVM.questionReject(question_id: questionData.pk)
                    }){
                        Text("거절하기")
                            .font(.system(size: 16, weight: .bold))
                            .frame(width: (width - 48) / 2, height: 40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("MainPrimary"), lineWidth: 1)
                            )
                            .foregroundColor(Color("MainPrimary"))
                            .padding(.trailing, 16)
                    }
                    Text("답변하기")
                        .font(.system(size: 16, weight: .bold))
                        .frame(width: (width - 48) / 2, height: 40)
                        .foregroundColor(Color.white)
                        .background(Color("MainPrimary"))
                        .cornerRadius(8)
                }
            }
            .padding(16)
        }
        .frame(width: width)
        .frame(minHeight: 130)
        .fixedSize(horizontal: false, vertical: true)
        .mask(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color("Button Grey"), radius: 3, x: 0, y: 1)
    }
}

struct ArrivedCard_Previews: PreviewProvider {
    static var previews: some View {
        ArrivedCard(questionData: ResultDetail(pk: 2, nickname: "안녕안녕", content: "안녕안녕", createdDate: "2023-03-26T22:01:42.000000", answerContent: "안녕안녕")).environmentObject(ChattyVM())
    }
}
