//
//  QuestionEditor.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/04/09.
//

import SwiftUI

struct QuestionEditor: View {
    @EnvironmentObject var chattyVM: ChattyVM
    @Environment(\.dismiss) var dismiss
    
    @State private var content: String = ""
    @State var username: String = ""
    @State var anonymous: Bool = false
    
    var body: some View {
        ZStack{
            Color.white
            VStack(alignment: .leading, spacing: 0){
                HStack(spacing: 0){
                    Text("질문 작성")
                        .font(Font.system(size: 20, weight: .bold))
                    Spacer()
                    Button(action: {
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
                .padding(.bottom, 16)
                HStack(spacing: 0){
                    Text("To @")
                        .font(.system(size:12))
                    Text("\(username)")
                        .font(.system(size:12, weight: .bold))
                }
                .foregroundColor(Color("Main Primary"))
                .padding(.bottom, 16)
//                HStack(spacing: 0){
//                    Toggle(isOn: $anonymous){
//                        Text("익명으로 쓰기")
//                            .font(.system(size:14, weight: .none))
//                    }
//                }
//                .padding(.bottom, 16)
                //질문 입력창
                ZStack(alignment: .topLeading){
                    Text("@\(username)에게 질문하기")
                        .foregroundColor(Color.gray)
                        .font(.system(size:16, weight: .bold))
                    TextEditor(text: $content)
                        .frame(height: 120)
                        .font(.system(size:16, weight: .none))
                        .opacity(content.isEmpty ? 0.1 : 1)
                }
                //완료 버튼
                Button(action:{
                    print(username, content)
                    chattyVM.questionPost(username: username, content: content)
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

struct QuestionEditor_Previews: PreviewProvider {
    static var previews: some View {
        QuestionEditor().environmentObject(ChattyVM())
    }
}
