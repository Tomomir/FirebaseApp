//
//  HomeCoordinator.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

struct HomeInputData { }

struct HomeOutputData { }

private struct HomeStoryboard: StoryboardType {
    static let name = "Home"
    static let navigationController = StoryboardReference<HomeStoryboard, UINavigationController>(id: "HomeNavigationControllerID")
    static let viewController = StoryboardReference<HomeStoryboard, HomeViewController>(id: "HomeViewControllerID")
}

final class HomeCoordinator: Coordinator<HomeInputData, HomeOutputData?> {

    // MARK: - Lifecycle

    func start() {
        let navigationController = HomeStoryboard.navigationController.instantiate()
        let viewController = navigationController.topViewController as? HomeViewController
        viewController?.viewModel = HomeViewModel(coordinator: self, viewController: viewController, inputData: inputData)
        presentByReplaceWindow(destinationNavigationController: navigationController, viewController: viewController, animated: true)
    }
}

extension HomeCoordinator {
    func showSignup(mode: SignupViewModel.Mode, delegate: SignupViewModelDelegate) {
        let coordinator = SignupCoordinator(type: .modal(viewController), inputData: SignupInputData(mode: mode, delegate: delegate), completion: nil)
        coordinator.start()
    }

    func showDetail(text: String) {
        let coordinator = DetailCoordinator(type: .modal(viewController), inputData: DetailInputData(text: text), completion: nil)
        coordinator.start()
    }

    func showNewRequest() {
        let coordinator = NewRequestCoordinator(type: .modal(viewController), inputData: NewRequestInputData(), completion: nil)
        coordinator.start()
    }
    
    func showImagePicker(delegate: ImagePickerDelegate) {
        if let homeVC = viewController as? HomeViewController {
            
            let imagePicker = ImagePicker(presentationController: homeVC, delegate: delegate)
            homeVC.viewModel.imagePicker = imagePicker
            imagePicker.present(from: homeVC.view)
        }
    }
}
