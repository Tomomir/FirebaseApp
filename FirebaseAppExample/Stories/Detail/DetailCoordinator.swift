//
//  DetailCoordinator.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

struct DetailInputData {
    let text: String
}

struct DetailOutputData { }

private struct DetailStoryboard: StoryboardType {
    static let name = "Detail"
    static let navigationController = StoryboardReference<DetailStoryboard, UINavigationController>(id: "DetailNavigationControllerID")
    static let viewController = StoryboardReference<DetailStoryboard, DetailViewController>(id: "DetailViewControllerID")
}

final class DetailCoordinator: Coordinator<DetailInputData, DetailOutputData?> {

    // MARK: - Lifecycle

    func start() {
        let navigationController = DetailStoryboard.navigationController.instantiate()
        let viewController = navigationController.topViewController as? DetailViewController
        viewController?.viewModel = DetailViewModel(coordinator: self, viewController: viewController, inputData: inputData)
        presentByModal(destinationNavigationController: navigationController, viewController: viewController)
    }
}

extension DetailCoordinator {

}
