//
//  CardView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/02/25.
//

import SwiftUI

struct CardView: View {
    var body: some View {
        ZStack {
            Color.white
                VStack(alignment:.leading){
                    HStack{
                        Text("익명의 질문자")
                            .font(Font.system(size: 14, weight: .bold))
                        Spacer()
                        Image(systemName: "poweroff")
                            .font(Font.system(size: 14, weight: .none))
                    }
                    .padding(.bottom, 5)
                    Text("속에 보이는 품었기 그들의 뿐이다. 따뜻한 것은 원대하고")
                        .font(Font.system(size: 16, weight: .none))
                        .padding(.bottom, 5)
                    Text("47분전")
                        .font(Font.system(size: 14, weight: .light))
                        .padding(.bottom, 5)
                    Text("열매를 그들의 가치를 가치를 것이다. 지혜는 청춘을 얼음과 쓸쓸하랴")
                        .fontWeight(.bold)
                        .frame(width: 320, height: 75)
                        .foregroundColor(Color("Main Color"))
                        .background(Color("Button Grey"))
                        .cornerRadius(16)
                }
            .padding()
        }
        .frame(width:360, height: 240)
        .mask(RoundedRectangle(cornerRadius: 20))
        .shadow(
            color: Color("Main Background"),
            radius: CGFloat(20)
        )
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
    }
}
