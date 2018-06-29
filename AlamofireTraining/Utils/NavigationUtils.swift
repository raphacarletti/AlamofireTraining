//
//  NavigationUtils.swift
//  AlamofireTraining
//
//  Created by Raphael Carletti on 6/29/18.
//  Copyright © 2018 Raphael Carletti. All rights reserved.
//

import Foundation
import UIKit

class NavigationUtils {
    static func goToLogin() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let window = appDelegate.window, let vc = UIStoryboard(name: StoryboardNames.login, bundle: nil).instantiateInitialViewController() else {
            return
        }
        
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
    
    static func goToMain() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let window = appDelegate.window, let vc = UIStoryboard(name: StoryboardNames.tabBar, bundle: nil).instantiateInitialViewController() else {
            return
        }
        
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
}
