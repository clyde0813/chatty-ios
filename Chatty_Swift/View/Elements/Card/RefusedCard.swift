//
//  RejectedCardView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/04/09.
//

import SwiftUI

struct RefusedCard: View {
    
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
                    .padding(.trailing, 15)
            }
            .padding(16)
        }
        .frame(width: width)
        .fixedSize(horizontal: false, vertical: true)
        .mask(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color("Button Grey"), radius: 3, x: 0, y: 1)    }
}

struct RefusedCard_Previews: PreviewProvider {
    static var previews: some View {
        RefusedCard(questionData: ResultDetail(pk: 2, nickname: "안녕안녕", content: "야 나랑 놀자 밤늦게까지 함께 손뼉 치면서 나랑 마셔 너와 나의 몸이 녹아 내리면 나랑 걷자 저 멀리까지가다 지쳐 누우면 나랑 자자 두 눈 꼭 감고 나랑 입 맞추자", createdDate: "2023-03-26T22:01:42.000000", answerContent: "안녕안녕"))
    }
}
