import SwiftUI
import Kingfisher

struct QuestionCard: View {
    @State var cardWidth : CGFloat
    @State var questionModel : ResultDetail
    
    init(cardWidth:CGFloat ,questionModel: ResultDetail) {
        self.cardWidth = cardWidth
        self.questionModel = questionModel
    }
    
    var body: some View {
        NavigationLink {
            ProfileView(username: .constant(questionModel.profile.username), isOwner: false)
        } label: {
            ZStack{
                Color.white
                VStack(alignment: .leading,spacing: 5){
                    responseState
                        .padding(.bottom,2)
                    
                    if questionModel.author == nil{
                        NilQuestion
                    }
                    else{
                        NotNilQuestion
                    }
                    
                    // 완료된 답변일시,
                    if questionModel.answerContent != nil {
                        answered
                    }
                }
                .padding([.leading, .trailing, .bottom], 16)
                .padding(.top, 12)
            }
            .frame(width: cardWidth)
            .frame(minHeight: 0)
            .fixedSize(horizontal: false, vertical: true)
            .mask(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color("Shadow Card"), radius: 3, x: 0, y: 7)
        }

        
        
    }
}

extension QuestionCard {
    var responseState : some View {
        HStack{
            if questionModel.refusalStatus {
                Text("거절된 답변")
                    .padding(.horizontal,10)
                    .padding(.vertical,3)
                    .font(Font.system(size: 14, weight: .bold))
                    .foregroundColor(.black)
                    .background(Color("Grey200"))
                    .cornerRadius(10)
            }
            else {
                if questionModel.answerContent == nil {
                    Text("답변 전")
                        .padding(.horizontal,10)
                        .padding(.vertical,3)
                        .font(Font.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .background(Color("Orange Main"))
                        .cornerRadius(10)
                }
                else {
                    Text("완료된 답변")
                        .padding(.horizontal,10)
                        .padding(.vertical,3)
                        .font(Font.system(size: 14, weight: .bold))
                        .foregroundColor(Color("Pink Dark"))
                        .background(Color("Pink Lighter"))
                        .cornerRadius(10)
                }
            }
            Spacer()
        }
    }
    
    //익명일떄 질문양식
    var NilQuestion : some View {
        VStack(alignment: .leading, spacing: 5){
            HStack{
                Text("To ")
                    .foregroundColor(Color("Main Primary"))
                    .font(.system(size: 14))
                Text("@\(questionModel.profile.username)")
                    .foregroundColor(Color("Main Primary"))
                    .font(Font.system(size: 15, weight: .bold))
                    
            }
            Text(questionModel.content)
                .font(Font.system(size: 16, weight: .none))
                .padding(.trailing, 5)
        }
    }
    
    //익명이 아닐때 질문양식
    var NotNilQuestion : some View {
        HStack{
            KFImage(URL(string:"\(questionModel.author?.profileImage ?? "")"))
                .resizable()
                .scaledToFill()
                .frame(width: 45, height: 45)
                .clipShape(Circle())
                .overlay(Circle()
                    .stroke(Color.white, lineWidth: 3))
                .clipped()
                .padding(.trailing, 8)
            VStack(alignment: .leading,spacing: 5){
                HStack(spacing: 4){
                    Text(questionModel.author?.profileName ?? "")
                        .font(Font.system(size: 16, weight: .bold))
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Text("@\(questionModel.author?.username ?? "")")
                        .font(Font.system(size: 12, weight: .semibold))
                        .foregroundColor(Color.gray)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Text("\(elapsedtime(time: questionModel.createdDate))")
                        .font(Font.system(size: 12, weight: .semibold))
                        .foregroundColor(Color.gray)
                    Spacer()
                }
                Text(questionModel.content)
                    .font(Font.system(size: 16, weight: .none))
                    .padding(.trailing, 5)
            }
        }
        .padding(.bottom, 4)
    }
    
    //답변영역
    var answered : some View {
        HStack(alignment: .top, spacing: 0){
            //답변 표현 화살표
            Image(systemName: "arrow.turn.down.right")
                .foregroundColor(Color("Main Primary"))
                .fontWeight(.semibold)
                .font(Font.system(size: 16, weight: .bold))
                .padding([.top, .trailing], 4)
            //Profile 사진
            HStack{
                KFImage(URL(string:"\(questionModel.profile.profileImage)"))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
                    .overlay(Circle()
                        .stroke(Color.white, lineWidth: 3))
                    .clipped()
                    .padding(.trailing, 8)
                VStack(alignment: .leading,spacing: 8){
                    HStack(spacing: 4){
                        Text(questionModel.profile.profileName)
                            .font(Font.system(size: 16, weight: .bold))
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Text("@\(questionModel.profile.username)")
                            .font(Font.system(size: 12, weight: .semibold))
                            .foregroundColor(Color.gray)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Text("\(elapsedtime(time: questionModel.answeredDate ?? ""))")
                            .font(Font.system(size: 12, weight: .semibold))
                            .foregroundColor(Color.gray)
                        Spacer()
                    }
                    Text(questionModel.answerContent ?? "")
                        .font(Font.system(size: 16, weight: .none))
                        .padding(.trailing, 5)
                }
            }
        }
        .padding(.horizontal,5)
        .padding(.top,5)
    }
}
