//import UIKit
//
//struct NavigationUtil {
//    static func popToRootView() {
//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }),
//           let rootViewController = keyWindow.rootViewController {
//            findNavigationController(viewController: rootViewController)?.popToRootViewController(animated: true)
//            print("popToRootView!!!")
//        }
//    }
//
//    static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
//        guard let viewController = viewController else {
//            return nil
//        }
//
//        if let navigationController = viewController as? UINavigationController {
//            return navigationController
//        }
//
//        for childViewController in viewController.children {
//            if let navigationController = findNavigationController(viewController: childViewController) {
//                return navigationController
//            }
//        }
//
//        return nil
//    }
//}
import UIKit

struct NavigationUtil {
    static func popToRootView() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }),
              let rootViewController = keyWindow.rootViewController else {
            return
        }
        
        if let tabBarController = rootViewController as? UITabBarController,
           let selectedNavigationController = tabBarController.selectedViewController as? UINavigationController {
            selectedNavigationController.popToRootViewController(animated: true)
            print("popToRootView!!!")
        } else {
            findNavigationController(viewController: rootViewController)?.popToRootViewController(animated: true)
            print("popToRootView!!!")
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
