//
//  CardView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/02/25.
//

import SwiftUI
import Kingfisher
import Combine
struct ResponsedCard: View {
    
    let width : CGFloat
    
    let currentTab : PostTab
    
    @ObservedObject var cardVM : CardVM
    
    @State var optionShow = false
    
    @State var anserSheetShow = false
    
    init(width:CGFloat, chatty: ResultDetail, currentTab:PostTab){
        self.width = width
        self.cardVM = CardVM(chatty: chatty)
        self.currentTab = currentTab
    }

    var body: some View {
        ZStack{
            Color.white
            VStack(alignment: .leading,spacing: 10){
                
                if cardVM.chatty.author == nil{
                    NilQuestion
                }
                else{
                    NotNilQuestion
                }
                
                // 완료된 답변일시,
                if currentTab == .responsedTab{
                    answered
                }
                
                //
                if currentTab == .arrivedTab {
                    anserButtonView
                }else {
                    bottomBar
                }
                
            }
            .padding([.leading, .trailing, .bottom], 16)
            .padding(.top, 12)
        }
        .sheet(isPresented: $optionShow, onDismiss: {optionShow = false}) {
            QuestionOption(chatty: cardVM.chatty)
                .presentationDetents(cardVM.chatty.profile.username == KeyChain.read(key: "username")  ? [.fraction(0.4)] : [.fraction(0.2)])
        }
        .sheet(isPresented: $anserSheetShow, onDismiss: {anserSheetShow = false}){
            AnswerEditor(chatty: cardVM.chatty)
                .presentationDetents([.fraction(0.45)])
        }
        .frame(width: width)
        .frame(minHeight: 0)
        .fixedSize(horizontal: false, vertical: true)
        .mask(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color("Shadow Card"), radius: 3, x: 0, y: 7)
    }
}

extension ResponsedCard {
    //익명일떄 질문양식
    var NilQuestion : some View {
        VStack(alignment: .leading, spacing: 5){
            HStack(spacing: 0){
                Text("From @")
                    .font(.system(size:12))
                    .foregroundColor(Color("Main Primary"))
                Text("익명")
                    .font(.system(size:12, weight: .bold))
                    .padding(.trailing, 8)
                    .foregroundColor(Color("Main Primary"))
                Text("•")
                    .font(Font.system(size: 12, weight: .semibold))
                    .foregroundColor(Color.gray)
                    .padding(.trailing, 8)
                Text("\(elapsedtime(time: cardVM.chatty.createdDate))")
                    .font(Font.system(size: 12, weight: .semibold))
                    .foregroundColor(Color.gray)
                Spacer()
                Button(action : {
                    optionShow.toggle()
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
            Text(cardVM.chatty.content)
                .font(Font.system(size: 16, weight: .none))
                .padding(.trailing, 5)
        }
    }

    //익명이 아닐때 질문양식
    var NotNilQuestion : some View {
        HStack{
            NavigationLink(value: StackPath.profileView(cardVM.chatty.author?.username ?? "")) {
                KFImage(URL(string:"\(cardVM.chatty.author?.profileImage ?? "")"))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
                    .overlay(Circle()
                        .stroke(Color.white, lineWidth: 3))
                    .clipped()
                    .padding(.trailing, 8)
            }

            VStack(alignment: .leading,spacing: 5){
                HStack(spacing: 4){
                    Text(cardVM.chatty.author?.profileName ?? "")
                        .font(Font.system(size: 16, weight: .bold))
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Text("@\(cardVM.chatty.author?.username ?? "")")
                        .font(Font.system(size: 12, weight: .semibold))
                        .foregroundColor(Color.gray)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Text("\(elapsedtime(time: cardVM.chatty.createdDate))")
                        .font(Font.system(size: 12, weight: .semibold))
                        .foregroundColor(Color.gray)
                    Spacer()
                    Button(action : {
                        optionShow.toggle()
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
                Text(cardVM.chatty.content)
                    .font(Font.system(size: 16, weight: .none))
                    .padding(.trailing, 5)
            }
        }
        .padding(.bottom, 4)
    }

    // 새로운 질문일시,
    var anserButtonView : some View {
        HStack(spacing: 0){
            Button(action:{
                cardVM.questionRefuse()
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
                anserSheetShow.toggle()
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
            HStack(alignment: .top){
                //MARK: - 수정해야함
                NavigationLink(value: StackPath.profileView(cardVM.chatty.profile.username)) {
                    KFImage(URL(string:"\(cardVM.chatty.profile.profileImage)"))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                        .overlay(Circle()
                            .stroke(Color.white, lineWidth: 3))
                        .clipped()
                        .padding(.trailing, 8)
                }

                VStack(alignment: .leading,spacing: 8){
                    HStack(spacing: 4){
                        Text(cardVM.chatty.profile.profileName)
                            .font(Font.system(size: 16, weight: .bold))
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Text("@\(cardVM.chatty.profile.username)")
                            .font(Font.system(size: 12, weight: .semibold))
                            .foregroundColor(Color.gray)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        Text("\(elapsedtime(time: cardVM.chatty.answeredDate ?? ""))")
                            .font(Font.system(size: 12, weight: .semibold))
                            .foregroundColor(Color.gray)
                        Spacer()
                    }
                    Text(cardVM.chatty.answerContent ?? "")
                        .font(Font.system(size: 16, weight: .none))
                        .padding(.trailing, 5)
                }
            }
        }
        .padding(.horizontal,5)
        .padding(.top,5)

    }

    //좋아요, 저장, 공유
    var bottomBar : some View {
        HStack(spacing: 0){
            Spacer()
            HStack(spacing: 3){
                Button {
                    cardVM.likeChatty()
                } label: {
                    if cardVM.chatty.likeStatus {
                        Image(systemName: "heart.fill")
                            .fontWeight(.semibold)
                            .font(Font.system(size: 16, weight: .bold))
                            .foregroundColor(.red)
                    }else {
                        Image(systemName: "heart")
                            .fontWeight(.semibold)
                            .font(Font.system(size: 16, weight: .bold))
                    }
                }
                Text("\(cardVM.chatty.like)")
                    .font(Font.system(size: 14, weight: .semibold))
                    .foregroundColor(Color("Text Light Primary"))
            }
            .frame(width: (width-32) / 2)

//                    Button {
//                        print("bookMark!!")
//                    } label: {
//                        Image(systemName: "bookmark")
//                            .fontWeight(.semibold)
//                            .font(Font.system(size: 16, weight: .bold))
//                            .frame(width: (width-32) / 3)
//                    }


            Button {
                UIPasteboard.general.string = "chatty.kr/\(cardVM.chatty.profile.username)"
                ChattyEventManager.share.showAlter.send("복사완료!")
            } label: {
                Image(systemName: "square.and.arrow.up")
                    .fontWeight(.semibold)
                    .font(Font.system(size: 16, weight: .bold))
                    .frame(width: (width-32) / 2)
            }


        }
    }
}
