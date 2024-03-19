//
//  AppDelegate.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var coordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        coordinator = AppCoordinator()
        coordinator?.start()
        
        return true
    }
}

