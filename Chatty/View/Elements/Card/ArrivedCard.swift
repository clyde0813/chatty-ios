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
    @StateObject var profileVM = ProfileVM()
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
                            .frame(width:20, height: 20)
                        }
                    }
                }
                .padding(.bottom, 4)
                Text("\(questiondata.content)")
                    .font(Font.system(size: 16, weight: .none))
                    .padding(.bottom, 16)
                    .padding(.trailing, 15)
                HStack(spacing: 0){
                    Button(action:{
                        profileVM.questionRefuse(question_id: questiondata.pk)
                    }){
                        Text("거절하기")
                            .font(.system(size: 16, weight: .bold))
                            .frame(width: (width - 48) / 2, height: 40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("Main Primary"), lineWidth: 1)
                            )
                            .foregroundColor(Color("Main Primary"))
                            .padding(.trailing, 16)
                    }
                    Button(action:{
                        chattyVM.questiondata = self.questiondata
                        chattyVM.answerEditorStatus = true
                    }){
                        Text("답변하기")
                            .font(.system(size: 16, weight: .bold))
                            .frame(width: (width - 48) / 2, height: 40)
                            .foregroundColor(Color.white)
                            .background(Color("Main Primary"))
                            .cornerRadius(8)
                    }
                }
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

//struct ArrivedCard_Previews: PreviewProvider {
//    static var previews: some View {
//        ArrivedCard(questiondata: ResultDetail(pk: 2, content: "안녕안녕", createdDate: "2023-03-26T22:01:42.000000", answerContent: "안녕안녕")).environmentObject(ChattyVM())
//    }
//}
