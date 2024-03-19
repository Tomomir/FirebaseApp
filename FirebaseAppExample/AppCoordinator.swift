//
//  AppCoordinator.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

final class AppCoordinator {

    // MARK: - Properties

    var window: UIWindow?

    // MARK: - Init

    init() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .black
        window?.makeKeyAndVisible()
    }

    // MARK: - Lifecycle

    func start() {
        showHome()
    }
}

extension AppCoordinator {
    func showHome() {
        let coordinator = HomeCoordinator(type: .replaceWindow(window), inputData: HomeInputData())
        coordinator.start()
    }
}
