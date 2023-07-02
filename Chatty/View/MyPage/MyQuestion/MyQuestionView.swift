//
//  MyQuestionView.swift
//  Chatty
//
//  Created by Hyeonho on 2023/06/30.
//

import SwiftUI

enum QuestionTab : String{
    case responsedTab = "responsed"
    case arrivedTab = "arrived"
    case refusedTab = "refused"
}

struct MyQuestionView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var currentTab : QuestionTab = .responsedTab
    
    @State var myQuestionVM = MyQuestionVM()
    
    var body: some View {
        VStack{
            navView
                .background(Rectangle()
                    .fill(Color.white)
                    .shadow(color: Color("Shadow Button"), radius: 3, x: 0, y: 6)
                )
            tabChangeBar
            
            GeometryReader { proxy in
                ScrollView{
                    LazyVStack{
                        
                        if currentTab == .responsedTab {
                            
                        }
                    }
                }
            }
            
            Spacer()
        }
        .toolbar(.hidden)
    }
}


extension MyQuestionView {
    var navView : some View {
        HStack(spacing: 25){
            Button(action:{
                dismiss()
            }){
                Image(systemName: "arrow.left")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            Spacer()
            Text("질문 모아보기")
                .font(.system(size: 18))
                .fontWeight(.medium)
                .foregroundColor(.black)
            Spacer()
            Button(action:{
                dismiss()
            }){
                Image(systemName: "arrow.left")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            .opacity(0)
        }
        .padding(.horizontal,24)
        .padding(.vertical,14)
    }
    
    var tabChangeBar : some View {
        HStack(spacing: 20){
            ZStack(alignment: .bottom){
                Button(action: {
                    currentTab = .responsedTab
                }){
                    if currentTab == .responsedTab {
                        VStack(alignment: .center, spacing: 0){
                            Text("보낸질문")
                                .font(Font.system(size: 16, weight: .bold))
                                .accentColor(.black)
                                .padding(.bottom, 9)
                            Rectangle()
                                .fill(Color("Main Secondary"))
                                .frame(width: 50, height: 3)
                        }
                    } else {
                        Text("보낸질문")
                            .font(Font.system(size: 16, weight: .semibold))
                            .foregroundColor(Color.gray)
                            .padding(.bottom, 12)
                    }
                }
                .accentColor(.black)
            }
            Spacer()
            ZStack(alignment: .bottom){
                Button(action: {
                    currentTab = .arrivedTab
                }){
                    if currentTab == .arrivedTab {
                        VStack(alignment: .center, spacing: 0){
                            Text("삭제된 질문")
                                .font(Font.system(size: 16, weight: .bold))
                                .accentColor(.black)
                                .padding(.bottom, 9)
                            Rectangle()
                                .fill(Color("Main Secondary"))
                                .frame(width: 50, height: 3)
                        }
                    } else {
                        Text("삭제된 질문")
                            .font(Font.system(size: 16, weight: .semibold))
                            .foregroundColor(Color.gray)
                            .padding(.bottom, 12)
                    }
                }
                .accentColor(.black)
            }
            Spacer()
            ZStack(alignment: .bottom){
                Button(action: {
                    currentTab = .refusedTab
                }){
                    if currentTab == .refusedTab {
                        VStack(alignment: .center, spacing: 0){
                            Text("거절된 질문")
                                .font(Font.system(size: 16, weight: .bold))
                                .accentColor(.black)
                                .padding(.bottom, 9)
                            Rectangle()
                                .fill(Color("Main Secondary"))
                                .frame(width: 50, height: 3)
                        }
                    } else {
                        Text("거절된 질문")
                            .font(Font.system(size: 16, weight: .semibold))
                            .foregroundColor(Color.gray)
                            .padding(.bottom, 12)
                    }
                }
                .accentColor(.black)
            }
        }
        .padding(.top,10)
        .padding(.horizontal, 20)
    }
}

struct MyQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        MyQuestionView()
    }
}
