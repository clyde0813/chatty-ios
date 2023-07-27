//
//  TestView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/04/23.
//

import SwiftUI
import Kingfisher

struct TestView: View {
//    @StateObject private var nativeViewModel = UnifiedNativeAdVM()
    var body: some View {
        VStack{
            Text("!")
//            UnifiedNativeAdView(nativeAdViewModel: nativeViewModel)
//                .frame(width: 300,height: 100)
        }
        .onAppear{
//            nativeViewModel.refreshAd()
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
