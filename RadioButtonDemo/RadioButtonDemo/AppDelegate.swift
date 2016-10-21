//
//  AppDelegate.swift
//  RadioButtonDemo
//
//  Created by Roland Leth on 19.10.2016.
//  Copyright © 2016 Roland Leth. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		window?.rootViewController = ViewController()
		window?.makeKeyAndVisible()
		
		return true
	}

}
