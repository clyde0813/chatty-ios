//
//  TestAdsView.swift
//  Chatty
//
//  Created by Hyeonho on 2023/09/02.
//

import SwiftUI

struct TestAdsView: View {
    @StateObject var viewmodel = ViewModel()
    var body: some View {
        VStack{
            NativeAdView(nativeAdViewModel: viewmodel)
                .frame(width: 400,height: 150)
        }
        .onAppear{
            viewmodel.refreshAd()
        }
    }
}

struct TestAdsView_Previews: PreviewProvider {
    static var previews: some View {
        TestAdsView()
    }
}
