//
//  RejectedCardView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/04/09.
//

import SwiftUI
import Kingfisher

struct RefusedCard: View {
    @EnvironmentObject var chattyVM: ChattyVM

    @State var width : CGFloat = 0.0
    
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
                            Spacer()
                        }
                        else {
                            HStack(alignment: .top,spacing: 0){
//                                NavigationLink {
//                                    ProfileView(username: .constant(questiondata.author?.username ?? ""))
//                                } label: {
//                                    KFImage(URL(string:"\(questiondata.author?.profileImage ?? "" )"))
//                                        .resizable()
//                                        .scaledToFill()
//                                        .frame(width: 45, height: 45)
//                                        .clipShape(Circle())
//                                        .overlay(Circle()
//                                            .stroke(Color.white, lineWidth: 3))
//                                        .clipped()
//                                        .padding(.trailing, 8)
//                                }
                                
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
                //                                    .padding(.bottom, questiondata.author == nil ? 0 : 40)
                                            }
                                            .frame(width:20, height: 20)
                                        }
                                    }
                                    .padding(.bottom, 8)
                                    Text(questiondata.content)
                                        .font(Font.system(size: 16, weight: .none))
                                        .padding(.trailing, 5)
                                }
                            }
                            .padding(.bottom, 16)
//                            .padding(.trailing, 15)
                        }
                        
                        
                        if questiondata.author == nil{
                            Button(action : {
                                eventVM.data = questiondata
                                eventVM.ShowSheet()
                                
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
                }
                .padding(.bottom, 4)
                if questiondata.author == nil {
                    Text("\(questiondata.content)")
                        .font(Font.system(size: 16, weight: .none))
                        .padding(.bottom, 16)
                        .padding(.trailing, 15)
                }
            }
            .padding([.leading, .trailing], 16)
//            .padding(.bottom, 10)
            .padding(.top, 12)
        }
        .frame(width: width)
        .fixedSize(horizontal: false, vertical: true)
        .mask(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color("Shadow Card"), radius: 3, x: 0, y: 7)
    }
}

//struct RefusedCard_Previews: PreviewProvider {
//    static var previews: some View {
//        RefusedCard(questiondata: ResultDetail(pk: 2, content: "야 나랑 놀자 밤늦게까지 함께 손뼉 치면서 나랑 마셔 너와 나의 몸이 녹아 내리면 나랑 걷자 저 멀리까지가다 지쳐 누우면 나랑 자자 두 눈 꼭 감고 나랑 입 맞추자", createdDate: "2023-03-26T22:01:42.000000", answerContent: "안녕안녕"))
//    }
//}
