import UIKit
import SwiftUI
struct NavigationUtil {
    static func popToRootView() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }),
              let rootViewController = keyWindow.rootViewController else {
            return
        }
        
//        if let tabBarController = rootViewController as? UITabBarController,
//           let selectedNavigationController = tabBarController.selectedViewController as? UINavigationController {
//            selectedNavigationController.popToRootViewController(animated: true)
//            print("this is TabController")
//        } else {
//            findNavigationController(viewController: rootViewController)?.popToRootViewController(animated: true)
//        }
        
        let rootView = MainView().eraseToAnyView()
        
        let hostingController = UIHostingController(rootView: rootView)
        
        if let tabBarController = hostingController as? UITabBarController {
           if let selectedNavigationController = tabBarController.selectedViewController as? UINavigationController {
             selectedNavigationController.popToRootViewController(animated: true)
             print("this is TabController")
           }
            else{
                print("NotNavigationController")
                findNavigationController(viewController: rootViewController)?.popToRootViewController(animated: true)
            }
        }
        else{
            print("NotTabBar")
            findNavigationController(viewController: rootViewController)?.popToRootViewController(animated: true)
        }
          
    }
    
    static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else {
            return nil
        }
        
        if let navigationController = viewController as? UINavigationController {
            return navigationController
        }
        
        for childViewController in viewController.children {
            if let navigationController = findNavigationController(viewController: childViewController) {
                return navigationController
            }
        }
        return nil
    }
}
extension View {
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
}
