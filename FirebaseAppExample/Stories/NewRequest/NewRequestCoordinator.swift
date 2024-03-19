//
//  NewRequestCoordinator.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

struct NewRequestInputData {

}

struct NewRequestOutputData { }

private struct NewRequestStoryboard: StoryboardType {
    static let name = "NewRequest"
    static let navigationController = StoryboardReference<NewRequestStoryboard, UINavigationController>(id: "NewRequestNavigationControllerID")
    static let viewController = StoryboardReference<NewRequestStoryboard, NewRequestViewController>(id: "NewRequestViewControllerID")
}

final class NewRequestCoordinator: Coordinator<NewRequestInputData, NewRequestOutputData?> {

    // MARK: - Lifecycle

    func start() {
        let navigationController = NewRequestStoryboard.navigationController.instantiate()
        let viewController = navigationController.topViewController as? NewRequestViewController
        viewController?.viewModel = NewRequestViewModel(coordinator: self, viewController: viewController, inputData: inputData)
        presentByModal(destinationNavigationController: navigationController, viewController: viewController)
    }
}

extension NewRequestCoordinator {

}
