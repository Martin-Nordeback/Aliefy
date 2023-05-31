//
//  Utilities.swift
//  ChatOrganizer
//
//  Created by Filip Hertzman on 2023-05-06.
//

import Foundation
import UIKit

// class so we can handle Google Sign in
final class Utilities {
    static let shared = Utilities()
    private init() {}

    //Need

    // Google sign in still use thing from UIKit, therefore we need access to UIViewController
    //topViewController let the app display google sign-in interface at the top of view hierarchy
    func topViewController(controller: UIViewController? = UIApplication.shared.connectedScenes
                            .filter({$0.activationState == .foregroundActive})
                            .compactMap({$0 as? UIWindowScene})
                            .first?.windows
                            .filter({$0.isKeyWindow}).first?.rootViewController) -> UIViewController? {
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
