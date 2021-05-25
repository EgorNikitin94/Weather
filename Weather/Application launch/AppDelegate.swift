//
//  AppDelegate.swift
//  Weather
//
//  Created by Егор Никитин on 03.05.2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        buildApp()
        
        return true
    }
    
    private func buildApp() {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let appCoordinator = AppCoordinator()
        
        window?.rootViewController = appCoordinator.navigator
        appCoordinator.start()
        
        window?.makeKeyAndVisible()
    }
}
