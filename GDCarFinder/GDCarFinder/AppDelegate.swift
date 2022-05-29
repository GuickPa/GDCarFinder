//
//  AppDelegate.swift
//  GDCarFinder
//
//  Created by Guglielmo Deletis on 25/05/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window:UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.rootViewController = GDTabBarController()
        window?.makeKeyAndVisible()

        return true
    }
}

