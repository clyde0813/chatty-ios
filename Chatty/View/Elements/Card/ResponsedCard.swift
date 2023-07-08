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
    
    @State var width : CGFloat = 0.0
    
    @State var questiondata : ResultDetail
    
    @ObservedObject var eventVM : ChattyEventVM

    var body: some View {
//        ZStack{
//            Color.white
//            VStack(alignment: .leading, spacing: 0){
//                HStack{
//                    HStack {
//                        if questiondata.author == nil {
//                            HStack(spacing: 0){
//                                Text("From @")
//                                    .font(.system(size:12))
//                                Text("익명")
//                                    .font(.system(size:12, weight: .bold))
//                                    .padding(.trailing, 8)
//                                Text("•")
//                                    .font(Font.system(size: 12, weight: .semibold))
//                                    .foregroundColor(Color.gray)
//                                    .padding(.trailing, 8)
//                                Text("\(elapsedtime(time: questiondata.createdDate))")
//                                    .font(Font.system(size: 12, weight: .semibold))
//                                    .foregroundColor(Color.gray)
//                            }
//                            .foregroundColor(Color("Main Primary"))
//                            Spacer()
//                        }
//                        else {
//                            HStack(alignment: .top,spacing: 0){
//                                NavigationLink {
//                                    ProfileView(username: .constant(questiondata.author?.username ?? ""), isOwner: false)
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
//                                VStack(alignment: .leading, spacing: 0){
//                                    HStack(spacing: 4){
//                                        Text(questiondata.author?.profileName ?? "")
//                                            .font(Font.system(size: 16, weight: .bold))
//                                        Text("@\(questiondata.author?.username ?? "")")
//                                            .font(Font.system(size: 12, weight: .semibold))
//                                            .foregroundColor(Color.gray)
//                                        Text("\(elapsedtime(time: questiondata.createdDate))")
//                                            .font(Font.system(size: 12, weight: .semibold))
//                                            .foregroundColor(Color.gray)
//                                        Spacer()
//                                        Button(action : {
//                                            eventVM.data = questiondata
//                                            if questiondata.profile.username == KeyChain.read(key: "username")! {
//                                                print("showMySheet!!")
//                                                eventVM.ShowSheet()
//                                            }else {
//                                                print("showOtherUserSheet!!")
//                                                eventVM.ShowOtherUserSheet()
//                                            }
//                                        }){
//                                            ZStack{
//                                                Image(systemName: "ellipsis")
//                                                    .foregroundColor(.black)
//                                                    .rotationEffect(.degrees(-90))
//                                                    .font(Font.system(size: 16, weight: .bold))
//                //                                    .padding(.bottom, questiondata.author == nil ? 0 : 40)
//                                            }
//                                            .frame(width:20, height: 20)
//                                        }
//                                    }
//                                    .padding(.bottom, 8)
//                                    Text(questiondata.content)
//                                        .font(Font.system(size: 16, weight: .none))
//                                        .padding(.trailing, 5)
//                                }
//                            }
////                            .padding(.bottom, 3)
////                            .padding(.trailing, 15)
//                        }
//
//
//                        if questiondata.author == nil{
//                            Button(action : {
//                                eventVM.data = questiondata
//
//                                if questiondata.profile.username == KeyChain.read(key: "username")! {
//                                    print("showMySheet!!")
//                                    eventVM.ShowSheet()
//                                }else {
//                                    print("showOtherUserSheet!!")
//                                    eventVM.ShowOtherUserSheet()
//                                }
//
//                            }){
//                                ZStack{
//                                    Image(systemName: "ellipsis")
//                                        .foregroundColor(.black)
//                                        .rotationEffect(.degrees(-90))
//                                        .font(Font.system(size: 16, weight: .bold))
//                                }
//                                .frame(width:20, height: 20)
//                            }
//                        }
//
//                    }
//                }
//                .padding(.bottom, 4)
//                if questiondata.author == nil {
//                    Text("\(questiondata.content)")
//                        .font(Font.system(size: 16, weight: .none))
//                        .padding(.bottom, 16)
//                        .padding(.trailing, 15)
//                }
//                //딥변 영역
//                HStack(alignment: .top, spacing: 0){
//                    //답변 표현 화살표
//                    Image(systemName: "arrow.turn.down.right")
//                        .foregroundColor(Color("Main Primary"))
//                        .fontWeight(.semibold)
//                        .font(Font.system(size: 16, weight: .bold))
//                        .padding([.top, .trailing], 4)
//                    //Profile 사진
//                    NavigationLink {
//                        ProfileView(username: .constant(questiondata.profile.username), isOwner: false)
//                    } label: {
//                        KFImage(URL(string:"\(questiondata.profile.profileImage)"))
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 45, height: 45)
//                            .clipShape(Circle())
//                            .overlay(Circle()
//                                .stroke(Color.white, lineWidth: 3))
//                            .clipped()
//                            .padding(.trailing, 8)
//                    }
//
//
//                    VStack(alignment: .leading, spacing: 0){
//                        HStack(spacing: 4){
//                            Text("\(questiondata.profile.profileName)")
//                                .font(Font.system(size: 16, weight: .bold))
//                            Text("•")
//                                .font(Font.system(size: 12, weight: .semibold))
//                                .foregroundColor(Color.gray)
//                                // ?? "2022-12-09T12:19:30"
//                            //MARK: - answeredDate로 수정해야함...
//                            Text("\(elapsedtime(time: questiondata.answeredDate ?? ""))")
//                                .font(Font.system(size: 12, weight: .semibold))
//                                .foregroundColor(Color.gray)
//                        }
//                        .padding(.bottom, 8)
//                        Text("\(questiondata.answerContent ?? "")")
//                            .font(Font.system(size: 16, weight: .none))
//                            .padding(.trailing, 5)
//                    }
//                }
//                .padding(.top, questiondata.author == nil ? 0 : 21)
//                .padding(.bottom, 16)
//
//                //좋아요, 저장, 공유
//                HStack(spacing: 0){
//                    Button {
//                        eventVM.data = questiondata
//                        eventVM.onClickLike()
//                        print("heart!")
//                    } label: {
//                        Image(systemName: "heart")
//                            .fontWeight(.semibold)
//                            .font(Font.system(size: 16, weight: .bold))
//                            .frame(width: (width-32) / 3)
//                    }
//                    Button {
//                        print("bookMark!!")
//                    } label: {
//                        Image(systemName: "bookmark")
//                            .fontWeight(.semibold)
//                            .font(Font.system(size: 16, weight: .bold))
//                            .frame(width: (width-32) / 3)
//                    }
//                    Button {
//                        print("share!")
//                    } label: {
//                        Image(systemName: "square.and.arrow.up")
//                            .fontWeight(.semibold)
//                            .font(Font.system(size: 16, weight: .bold))
//                            .frame(width: (width-32) / 3)
//                    }
//                }
//            }
//            .padding([.leading, .trailing, .bottom], 16)
//            .padding(.top, 12)
//        }
//        .frame(width: width)
//        .frame(minHeight: 0)
//        .fixedSize(horizontal: false, vertical: true)
//        .mask(RoundedRectangle(cornerRadius: 20))
//        .shadow(color: Color("Shadow Card"), radius: 3, x: 0, y: 7)
        ZStack{
            Color.white
            VStack(alignment: .leading,spacing: 10){


                if questiondata.author == nil{
                    NilQuestion
                }
                else{
                    NotNilQuestion
                }

                // 완료된 답변일시,
                answered
                HStack(spacing: 0){
                    Spacer()
                    HStack(spacing: 3){
                        Button {
                            eventVM.data = questiondata
                            eventVM.onClickLike()
                            questiondata.likeStatus.toggle()
                            if questiondata.likeStatus == true {
                                questiondata.like += 1
                            }else {
                                questiondata.like -= 1
                            }
                        } label: {
                            if questiondata.likeStatus {
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
                        Text("\(questiondata.like)")
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
                        UIPasteboard.general.string = "chatty.kr/\(questiondata.profile.username)"
                        eventVM.sharePublisher.send()
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .fontWeight(.semibold)
                            .font(Font.system(size: 16, weight: .bold))
                            .frame(width: (width-32) / 2)
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
                Text("\(elapsedtime(time: questiondata.createdDate))")
                    .font(Font.system(size: 12, weight: .semibold))
                    .foregroundColor(Color.gray)
                Spacer()
                Button(action : {
                    eventVM.data = questiondata
                    if questiondata.profile.username == KeyChain.read(key: "username")! {
                        print("showMySheet!!")
                        eventVM.ShowSheet()
                    }else {
                        print("showOtherUserSheet!!")
                        eventVM.ShowOtherUserSheet()
                    }
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
            Text(questiondata.content)
                .font(Font.system(size: 16, weight: .none))
                .padding(.trailing, 5)
        }
    }
    
    //익명이 아닐때 질문양식
    var NotNilQuestion : some View {
        HStack{
            KFImage(URL(string:"\(questiondata.author?.profileImage ?? "")"))
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
                        if questiondata.profile.username == KeyChain.read(key: "username")! {
                            print("showMySheet!!")
                            eventVM.ShowSheet()
                        }else {
                            print("showOtherUserSheet!!")
                            eventVM.ShowOtherUserSheet()
                        }
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
                Text(questiondata.content)
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
            HStack(alignment: .top){
                KFImage(URL(string:"\(questiondata.profile.profileImage)"))
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
                        Text(questiondata.profile.profileName)
                            .font(Font.system(size: 16, weight: .bold))
                        Text("@\(questiondata.profile.username)")
                            .font(Font.system(size: 12, weight: .semibold))
                            .foregroundColor(Color.gray)
                        Text("\(elapsedtime(time: questiondata.answeredDate ?? ""))")
                            .font(Font.system(size: 12, weight: .semibold))
                            .foregroundColor(Color.gray)
                        Spacer()
                    }
                    Text(questiondata.answerContent ?? "")
                        .font(Font.system(size: 16, weight: .none))
                        .padding(.trailing, 5)
                }
            }
        }
        .padding(.horizontal,5)
        .padding(.top,5)
        
    }
}
