//
//  MyPageView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/02/23.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject var userVM: UserVM
    
    var body: some View {
        VStack {
            //                Button(action: {userVM.logout()}){
            Button(action: {UserDefaults.standard.set(false, forKey: "isLoggedIn")}){
                Text("로그아웃")
                    .fontWeight(.bold)
                    .frame(width: 300, height: 60)
                    .foregroundColor(Color("White"))
                    .background(Color("Main Color"))
                    .cornerRadius(16)
                    .padding(.bottom, 20)
            }
        }
        //            .onReceive(userVM.logoutSuccess, perform: {
        //                print("Logout - logoutSuccess() called")
        //                UserDefaults.standard.set(false, forKey: "isLoggedIn")
        //                KeyChain.delete(key: "username")
        //                KeyChain.delete(key: "token")
        //                print(UserDefaults.standard.bool(forKey: "isLoggedIn"))
        //            })
        .tag(BottomTab.mypage)
        .tabItem{
            Image(systemName: "person.crop.circle.fill")
            Text("마이페이지")
        }
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView().environmentObject(UserVM())
    }
}
