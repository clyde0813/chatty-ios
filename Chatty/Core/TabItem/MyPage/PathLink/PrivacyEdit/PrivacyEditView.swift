//
//  PrivacyEditView.swift
//  Chatty
//
//  Created by Clyde on 2023/05/08.
//

import SwiftUI

struct PrivacyEditView: View {

    @Environment(\.presentationMode) var presentationMode

    @State var deleteAlter : Bool = false
    
    @State var msg = ""
    
    @State var showMsg = false
    
    @StateObject var viewmodel = PrivacyEditVM()
    
    
    
    var body: some View {
        GeometryReader{ proxy in
            ZStack{
                Color.white
                VStack(alignment: .center, spacing: 0){
                    HStack{
                        HStack{
                            Button(action:{
                                presentationMode.wrappedValue.dismiss()
                            }){
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(Color.black)
                                    .padding(.trailing, 20)
                            }
                            .padding(.leading, 30)
                            Spacer()
                        }
                        .frame(width: proxy.size.width / 3)
                        ZStack{
                            Image("Logo Small")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 32, height: 32)
                        }
                        .frame(width: proxy.size.width / 3)
                        ZStack{
                            
                        }
                        .frame(width: proxy.size.width / 3)
                    }
                    .frame(width: proxy.size.width, height: 60)
                    .background(Rectangle()
                        .fill(Color.white)
                        .shadow(color: Color("Shadow Button"), radius: 3, x: 0, y: 6)
                    )
                    
                    VStack(spacing: 0){
                        NavigationLink(value: myPageStack.EULAView) {
                            HStack{
                                Text("이용약관")
                                    .font(Font.system(size: 16, weight: .none))
                                    .foregroundColor(Color.black)
                                Spacer()
                                
                            }
                            .frame(height: 48)
                        }
                    }
                    .padding(.top, 20)
                    .padding([.leading, .trailing], 20)
                    
                    VStack(spacing: 0){
                        Button(action:{
                            self.deleteAlter = true
                        }){
                            HStack{
                                Text("회원 탈퇴")
                                    .font(Font.system(size: 16, weight: .none))
                                    .foregroundColor(Color.red)
                                Spacer()
                                
                            }
                            .frame(height: 48)
                        }
                    }
                    .padding([.leading, .trailing], 20)
                    Spacer()
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
                
                if showMsg {
                    PrivacyEditErrorView(msg: msg)
                }
                
                
            }
        }
        .navigationBarBackButtonHidden()
        .onReceive(ChattyEventManager.share.showAlter, perform: { result in
            msg = result
            showMsg = true
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                showMsg = false
            }
        })
        .alert("회원 탈퇴", isPresented: $deleteAlter){
            Button("취소", role: .cancel){
                
            }
            Button("삭제", role: .destructive) {
                viewmodel.unregister()
            }
        } message: {
            Text("가입 정보를 삭제하시겠습니까?")
        }
        

    }
}





struct PrivacyEditErrorView : View {
    
    let msg : String
    
    var body: some View{
        VStack{
            Spacer()
            HStack{
                Spacer()
                Text(msg)
                    .frame(width: 310, height: 40)
                    .foregroundColor(Color.white)
                    .background(Color("Error Background"))
                    .cornerRadius(16)
                    .padding(.bottom, 50)
                Spacer()
            }
        }
    }
}


