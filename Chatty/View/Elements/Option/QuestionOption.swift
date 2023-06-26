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
    
    @ObservedObject var eventVM : ChattyEventVM
    
    @State var isSaveImage = false
    
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
                
                
                if eventVM.data?.profile.username == KeyChain.read(key: "username") {
                    Button(action: {
                        isSaveImage = true
                    }){
                        HStack(spacing: 8){
                            Image(systemName: "photo.fill")
                                .font(Font.system(size: 16, weight: .bold))
                            Text("이미지 저장")
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
                    .fullScreenCover(isPresented: $isSaveImage){
                        ChattyShareView(eventVM: eventVM)
                    }
                    Button(action:{
                        dismiss()
                        eventVM.reportQuestion()
                    }){
                        HStack(spacing: 8){
                            Image(systemName: "light.beacon.max")
                                .font(Font.system(size: 16, weight: .bold))
                            Text("신고 & 차단하기")
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
                    .padding([.leading, .trailing, .bottom], 3)
                    
                    Button(action:{
                        dismiss()
                        eventVM.deleteQuestion()
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
                else{
                    Button(action:{
                        dismiss()
                        eventVM.reportQuestion()
                    }){
                        HStack(spacing: 8){
                            Image(systemName: "light.beacon.max")
                                .font(Font.system(size: 16, weight: .bold))
                            Text("신고 & 차단하기")
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
                    .padding([.leading, .trailing, .bottom], 3)
                    .clipped()
                }
            }
            .clipped()
            .padding(20)
        }
    }
}
//
//struct QuestionOption_Previews: PreviewProvider {
//    static var previews: some View {
//        QuestionOption()
//    }
//}
