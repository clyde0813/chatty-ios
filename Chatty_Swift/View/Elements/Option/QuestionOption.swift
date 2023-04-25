//
//  QuestionOption.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/04/18.
//

import SwiftUI

struct QuestionOption: View {
    @EnvironmentObject var chattyVM: ChattyVM
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack{
            Color.white
            VStack(alignment: .leading, spacing: 16){
                HStack(spacing: 0){
                    Text("이 질문을...")
                        .font(.system(size: 20, weight: .bold))
                    Spacer()
                    Button(action: {
                        chattyVM.questionOptionStatus = false
                        dismiss()
                    }){
                        Image(systemName: "xmark")
                            .foregroundColor(Color.black)
                            .fontWeight(.semibold)
                            .font(Font.system(size: 16, weight: .bold))
                    }
                }
                Button(action: {
                    chattyVM.questionOptionStatus = false
                    dismiss()
                    chattyVM.shareViewPass.send()
                }){
                    HStack(spacing: 8){
                        Image(systemName: "paperplane.fill")
                            .font(Font.system(size: 16, weight: .bold))
                        Text("공유하기")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .frame(height: 60)
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity
                    )
                    .foregroundColor(Color.white)
                    .background(Color("Main Primary"))
                    .cornerRadius(16)
                }
                
                Button(action:{
                    chattyVM.questionOptionStatus = false
                    dismiss()
                }){
                    HStack(spacing: 8){
                        Image(systemName: "light.beacon.max")
                            .font(Font.system(size: 16, weight: .bold))
                        Text("신고하기")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .frame(height: 60)
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity
                    )
                    .foregroundColor(Color("Pink Dark"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color("Pink Dark"), lineWidth: 2)
                    )
                }
                Button(action:{
                    chattyVM.questionOptionStatus = false
                    dismiss()
                }){
                    HStack(spacing: 8){
                        Image(systemName: "trash.fill")
                            .font(Font.system(size: 16, weight: .bold))
                        Text("삭제하기")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .frame(height: 60)
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity
                    )
                    .foregroundColor(Color.white)
                    .background(Color("Grey900"))
                    .cornerRadius(16)
                }
            }
            .padding(20)
        }
        .onAppear{
            print(chattyVM.questionOptionStatus)
        }
        .onTapGesture {
            chattyVM.questionOptionStatus = false
        }
    }
}
//
//struct QuestionOption_Previews: PreviewProvider {
//    static var previews: some View {
//        QuestionOption()
//    }
//}
