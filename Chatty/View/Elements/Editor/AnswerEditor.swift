//
//  AnswerEditor.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/04/16.
//

import SwiftUI

struct AnswerEditor: View {
    @EnvironmentObject var chattyVM: ChattyVM
    @Environment(\.dismiss) var dismiss
    
    @State private var content: String = ""
    @State var username: String = ""
    @State var anonymous: Bool = false
    
    @State var questiondata : ResultDetail

    var body: some View {
        ZStack{
            Color.white
            VStack(alignment: .leading, spacing: 0){
                HStack(spacing: 0){
                    Text("답변 작성")
                        .font(Font.system(size: 20, weight: .semibold))
                    Spacer()
                    Button(action: {
                        chattyVM.answerEditorStatus = false
                        dismiss()
                    }){
                        ZStack{
                            Image(systemName: "xmark")
                                .foregroundColor(Color.black)
                                .fontWeight(.semibold)
                                .font(Font.system(size: 16, weight: .bold))
                        }
                        .frame(width: 20, height: 20)
                    }
                }
                .padding(.bottom, 10)
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
                .padding(.bottom, 4)
                Text("\(questiondata.content)")
                    .font(Font.system(size: 16, weight: .none))
                    .padding(.bottom, 12)
                //질문 입력창
                ZStack(alignment: .topLeading){
                    Text("@익명에게 답변 쓰기")
                        .foregroundColor(Color.gray)
                        .font(.system(size:16, weight: .bold))
                    TextEditor(text: $content)
                        .frame(minHeight: 120)                        .font(.system(size:16, weight: .none))
                        .opacity(content.isEmpty ? 0.1 : 1)
                }
                //완료 버튼
                Button(action:{
                    chattyVM.answerPost(question_id: questiondata.pk, content: content)
                    chattyVM.answerEditorStatus = false
                    dismiss()
                }){
                    Text("완료")
                        .font(.system(size: 16, weight: .bold))
                        .frame(height: 60)
                        .frame(
                            minWidth: 0,
                            maxWidth: .infinity
                        )
                        .foregroundColor(Color.white)
                        .background(Color("Main Primary"))
                        .cornerRadius(8)
                }
            }
            .padding(20)
        }
        .onTapGesture {
            endEditing()
        }
    }
}

//struct AnswerEditor_Previews: PreviewProvider {
//    static var previews: some View {
//        AnswerEditor(question_content: "그럿개 살지마셈 ㅋ--^").environmentObject(ChattyVM())
//    }
//}
