
import SwiftUI
import Combine
import Kingfisher

struct ArrivedCard: View {
    @State var width : CGFloat = 0.0
    
    @ObservedObject var questionVM : QuestionVM
    
    @State var questiondata : ResultDetail

    @ObservedObject var eventVM : ChattyEventVM
    
    var body: some View {
        ZStack{
            Color.white
            VStack(alignment: .leading, spacing: 0){
                HStack{
                    HStack {
                        if questiondata.author == nil {
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
                        }
                        else {
                            HStack{
                                NavigationLink {
                                    ProfileView(username: .constant(questiondata.author?.username ?? ""), isOwner: false)
                                } label: {
                                    KFImage(URL(string:"\(questiondata.author?.profileImage ?? "" )"))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 45, height: 45)
                                        .clipShape(Circle())
                                        .overlay(Circle()
                                            .stroke(Color.white, lineWidth: 3))
                                        .clipped()
                                        .padding(.trailing, 8)
                                }
                                VStack(alignment: .leading, spacing: 0){
                                    HStack(spacing: 4){
                                        Text(questiondata.author?.profileName ?? "")
                                            .font(Font.system(size: 16, weight: .bold))
                                        Text("@\(questiondata.author?.username ?? "")")
                                            .font(Font.system(size: 12, weight: .semibold))
                                            .foregroundColor(Color.gray)
                                        Text("\(elapsedtime(time: questiondata.createdDate))")
                                            .font(Font.system(size: 12, weight: .semibold))
                                            .foregroundColor(Color.gray)
                                    }
                                    .padding(.bottom, 8)
                                    Text(questiondata.content)
                                        .font(Font.system(size: 16, weight: .none))
                                        .padding(.trailing, 5)
                                }
                            }
                            .padding(.bottom, 16)
                            .padding(.trailing, 15)
                        }
                        Spacer()
                        
                        Button(action : {
                            eventVM.data = questiondata
                            eventVM.ShowSheet()
                            
                        }){
                            ZStack{
                                Image(systemName: "ellipsis")
                                    .foregroundColor(.black)
                                    .rotationEffect(.degrees(-90))
                                    .font(Font.system(size: 16, weight: .bold))
                                    .padding(.bottom, questiondata.author == nil ? 0 : 40)
                            }
                            .frame(width:20, height: 20)
                        }
                    }
                }
                .padding(.bottom, 4)
                if questiondata.author == nil {
                    Text("\(questiondata.content)")
                        .font(Font.system(size: 16, weight: .none))
                        .padding(.bottom, 16)
                        .padding(.trailing, 15)
                }
                HStack(spacing: 0){
                    Button(action:{
                        questionVM.questionRefuse(question_id: questiondata.pk)
                        eventVM.refuseQuestion()
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
                        eventVM.data = questiondata
                        eventVM.answerSheetShow()
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
