//
//  SignupCoordinator.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

class SignupInputData {

    // MARK: - Properties

    var mode: SignupViewModel.Mode
    weak var delegate: SignupViewModelDelegate?

    // MARK: - Init

    init(mode: SignupViewModel.Mode, delegate: SignupViewModelDelegate?) {
        self.mode = mode
        self.delegate = delegate
    }
}

struct SignupOutputData { }

private struct SignupStoryboard: StoryboardType {
    static let name = "Signup"
    static let navigationController = StoryboardReference<SignupStoryboard, UINavigationController>(id: "SignupNavigationControllerID")
    static let viewController = StoryboardReference<SignupStoryboard, SignupViewController>(id: "SignupViewControllerID")
}

final class SignupCoordinator: Coordinator<SignupInputData, SignupOutputData?> {

    // MARK: - Lifecycle

    func start() {
        let navigationController = SignupStoryboard.navigationController.instantiate()
        let viewController = navigationController.topViewController as? SignupViewController
        viewController?.viewModel = SignupViewModel(coordinator: self, viewController: viewController, inputData: inputData)
        presentByModal(destinationNavigationController: navigationController, viewController: viewController)
    }
}

extension SignupCoordinator {
    func showForgotPassword() {
        let coordinator = SignupCoordinator(type: .modal(viewController), inputData: SignupInputData(mode: .forgotPassword, delegate: nil), completion: nil)
        coordinator.start()
    }
}
