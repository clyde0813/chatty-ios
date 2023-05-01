//
//  NewQuestionButton.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/04/09.
//

import SwiftUI

struct NewQuestionButton: View {
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 99)
                .fill(Color("Main Primary"))
                .frame(width: 115,height: 45)
                .shadow(color: Color("Shadow Button"), radius: 5, x: 0, y: 6)
            HStack{
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .font(Font.system(size: 16, weight: .bold))
                Text("질문하기")
                    .font(Font.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
        }
    }
}

struct NewQuestionButton_Previews: PreviewProvider {
    static var previews: some View {
        NewQuestionButton()
    }
}
