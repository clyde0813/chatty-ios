//
//  TestView.swift
//  Chatty_Swift
//
//  Created by Clyde on 2023/04/23.
//

import SwiftUI
import Kingfisher

struct TestView: View {
    @StateObject private var nativeViewModel = NativeViewModel()
    var body: some View {
        VStack{
            AdsView(nativeAdViewModel: nativeViewModel)
                .frame(width: 300,height: 50)
        }
        .onAppear {
              refreshAd()
            }
            
            
    }
    
    private func refreshAd() {
        nativeViewModel.refreshAd()
      }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
