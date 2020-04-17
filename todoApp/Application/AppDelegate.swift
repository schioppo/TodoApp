//
//  AppDelegate.swift
//  todoApp
//
//  Created by Alessandro Schioppetti on 14/04/2020.
//  Copyright © 2020 Codermine Srl. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let controller = MainViewController(nibName: "MainViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: controller)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        return true
    }

    


}

