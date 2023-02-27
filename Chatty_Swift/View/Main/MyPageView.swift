//
//  MyPageView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/02/23.
//

import SwiftUI

struct MyPageView: View {
    var body: some View {
        Color.red.edgesIgnoringSafeArea(.all)
            .tag(BottomTab.home)
            .tabItem{
                Image(systemName: "person.crop.circle.fill")
                Text("랭킹")
            }
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
