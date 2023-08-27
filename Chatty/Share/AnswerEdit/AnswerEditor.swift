
import SwiftUI
import Kingfisher

struct AnswerEditor: View {

    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var answerSheetVM : AnserSheetVM

    @State var content = ""

    init(chatty:ResultDetail){
        self.answerSheetVM = AnserSheetVM(chatty: chatty)
    }
    
    var body: some View {
        ZStack{
            Color.white
            VStack(alignment: .leading, spacing: 0){
                HStack(spacing: 0){
                    Text("답변 작성")
                        .font(Font.system(size: 20, weight: .semibold))
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
                .padding(.bottom, 10)
                
                if answerSheetVM.chatty.author == nil {
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
                        Text("\(elapsedtime(time: answerSheetVM.chatty.createdDate ))")
                            .font(Font.system(size: 12, weight: .semibold))
                            .foregroundColor(Color.gray)
                    }
                    .foregroundColor(Color("Main Primary"))
                    .padding(.bottom, 4)
                }else {
                    HStack{
                        KFImage(URL(string:answerSheetVM.chatty.author?.profileImage ?? ""))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 45, height: 45)
                                .clipShape(Circle())
                                .overlay(Circle()
                                    .stroke(Color.white, lineWidth: 3))
                                .clipped()
                                .padding(.trailing, 8)
                        
                        VStack(alignment: .leading, spacing: 0){
                            HStack(spacing: 4){
                                Text("From @")
                                    .font(.system(size:12))
                                Text(answerSheetVM.chatty.author?.username ?? "")
                                    .font(.system(size:12, weight: .bold))
                                    .padding(.trailing, 8)
                                Text("\(elapsedtime(time: answerSheetVM.chatty.createdDate))")
                                    .font(Font.system(size: 12, weight: .semibold))
                                    .foregroundColor(Color.gray)
                            }
                            .padding(.bottom, 8)
                            Text(answerSheetVM.chatty.content)
                                .font(Font.system(size: 16, weight: .none))
                                .padding(.bottom, 12)
                        }
                    }
                    .padding(.bottom,4)
                }
                if answerSheetVM.chatty.author == nil {
                    Text(answerSheetVM.chatty.content)
                        .font(Font.system(size: 16, weight: .none))
                        .padding(.bottom, 12)
                }
                
                //답변입력창
                ZStack(alignment: .topLeading){
                    Text(answerSheetVM.chatty.author == nil ? "@익명에게 답변 쓰기" : "@\(answerSheetVM.chatty.author?.username ?? "")에게 답변 쓰기")
                        .foregroundColor(Color.gray)
                        .font(.system(size:16, weight: .bold))
                    TextEditor(text: $content)
                        .frame(minHeight: 120)
                        .font(.system(size:16, weight: .none))
                        .opacity(content.isEmpty ? 0.1 : 1)
                }
                //완료 버튼
                Button(action:{
                    dismiss()
                    answerSheetVM.answerQuestion(content: content)
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
