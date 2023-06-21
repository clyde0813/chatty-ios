import SwiftUI
import GoogleMobileAds
import UIKit

private struct BannerVC: UIViewControllerRepresentable {
    var bannerID: String
    var width: CGFloat

    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(width))

        let viewController = UIViewController()
        #if DEBUG
        view.adUnitID = "ca-app-pub-3017845272648516/7121150693"
        #else
        view.adUnitID = bannerID
        #endif
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        view.load(GADRequest())

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct AdBannerView: View {
    var bannerID: String
    var width: CGFloat

    var size: CGSize {
        return GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(width).size
    }

    var body: some View {
        BannerVC(bannerID: bannerID, width: width)
            .frame(width: size.width, height: size.height)
    }
}

struct Banner_Previews: PreviewProvider {
    static var previews: some View {
        AdBannerView(bannerID: "ca-app-pub-3017845272648516/7121150693", width: UIScreen.main.bounds.width)
    }
}
