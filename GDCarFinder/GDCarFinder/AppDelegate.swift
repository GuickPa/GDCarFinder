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
        
        let loader = GDDataLoader()
        let listHandler = GDCarListHandler(decoder: GDGenericDataDecoder(), cellHandler: GDPoiTableViewCellHandler())
        let mainVC = GDListViewController(loader: loader, listHandler: listHandler)
        window?.rootViewController = mainVC
        window?.makeKeyAndVisible()

        return true
    }
}

