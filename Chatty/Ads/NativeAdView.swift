import SwiftUI
import GoogleMobileAds
import Foundation

struct NativeAdView: UIViewRepresentable {
//    typealias UIViewType = GADNativeAdView
    typealias UIViewType2 = GADTTemplateView
    
    @ObservedObject var nativeAdViewModel: ViewModel
    
    func makeUIView(context: Context) -> GADNativeAdView {
        
        let templateView = Bundle.main.loadNibNamed("GADTSmallTemplateView", owner: nil, options: nil)?.first as! GADTTemplateView
        
//        let myBlueColor = "#5C84F0"
//
//        let styles: [GADTNativeTemplateStyleKey: NSObject] = [
//            GADTNativeTemplateStyleKey.callToActionFont: UIFont.systemFont(ofSize: 15.0),
//            GADTNativeTemplateStyleKey.callToActionFontColor: UIColor.white,
//            GADTNativeTemplateStyleKey.callToActionBackgroundColor: GADTTemplateView.color(fromHexString: myBlueColor),
//            GADTNativeTemplateStyleKey.secondaryFont: UIFont.systemFont(ofSize: 15.0),
//            GADTNativeTemplateStyleKey.secondaryFontColor: UIColor.gray,
//            GADTNativeTemplateStyleKey.secondaryBackgroundColor: UIColor.white,
//            GADTNativeTemplateStyleKey.primaryFont: UIFont.systemFont(ofSize: 15.0),
//            GADTNativeTemplateStyleKey.primaryFontColor: UIColor.black,
//            GADTNativeTemplateStyleKey.primaryBackgroundColor: UIColor.white,
//            GADTNativeTemplateStyleKey.tertiaryFont: UIFont.systemFont(ofSize: 15.0),
//            GADTNativeTemplateStyleKey.tertiaryFontColor: UIColor.gray,
//            GADTNativeTemplateStyleKey.tertiaryBackgroundColor: UIColor.white,
//            GADTNativeTemplateStyleKey.mainBackgroundColor: UIColor.white,
//            GADTNativeTemplateStyleKey.cornerRadius: NSNumber(value: 7.0)
//        ]
//
//        templateView.styles = styles
        
        return templateView
    }
    
    func updateUIView(_ nativeAdView: GADNativeAdView, context: Context) {
        guard let nativeAd = nativeAdViewModel.nativeAd else { return }
        
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
        
        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        
        (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
        
        (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
        
        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        
        
        nativeAdView.callToActionView?.isUserInteractionEnabled = false
        
        nativeAdView.nativeAd = nativeAd
    }
}
