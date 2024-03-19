//
//  SignupViewModel.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

protocol SignupViewModelDelegate: AnyObject {
    func updateUserState()
}

final class SignupViewModel {

    // MARK: - Types

    enum Mode {
        case signup
        case login
        case forgotPassword

        var title: String {
            switch self {
            case .signup:
                return "Vytvoriť účet"
            case .login:
                return "Prihlásiť sa"
            case .forgotPassword:
                return "Resetovať heslo"
            }
        }

        var primaryButtonTitle: String {
            return title
        }
    }

    var mode: Mode {
        inputData.mode
    }

    var isModeSignup: Bool {
        mode == .signup
    }

    var isModeLogin: Bool {
        mode == .login
    }

    var isModeForgotPassword: Bool {
        mode == .forgotPassword
    }

    // MARK: - Properties

    private let coordinator: SignupCoordinator
    private weak var viewController: SignupViewControllerActions?
    private let inputData: SignupInputData

    var email: String?
    var password: String?
    var passwordAgain: String?

    // MARK: - CellModels

    var cellModels: [CellModel] = []

    // MARK: - Init

    init(coordinator: SignupCoordinator, viewController: SignupViewControllerActions?, inputData: SignupInputData) {
        self.coordinator = coordinator
        self.viewController = viewController
        self.inputData = inputData
    }

    // MARK: - Lifecycle

    func viewDidLoad() {
        updateLayoutForCurrentMode()
    }

    // MARK: - Actions

    func forgotPasswordButtonTapped() {
        inputData.mode = .forgotPassword
        viewController?.setupLayout(for: mode)
    }

    func primaryButtonTapped() {
        let isEmailEmpty = email?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        let isEmailValid = true
        let isPasswordEmpty = password?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        let isPasswordAgainEmpty = isModeLogin ? false : passwordAgain?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        let arePasswordsMatching = isModeLogin ? true : password == passwordAgain

        switch (isEmailEmpty, isEmailValid, isPasswordEmpty, isPasswordAgainEmpty, arePasswordsMatching) {
        case (true, _, _, _, _):
            coordinator.showAlertOneButton(title: "Zadajte e-mail", oneButtonTitle: "Rozumiem")
            return
        case (false, false, _, _, _):
            coordinator.showAlertOneButton(title: "E-mail nie je v správnom formáte", oneButtonTitle: "Rozumiem")
            return
        case (false, true, true, _, _):
            coordinator.showAlertOneButton(title: "Zadajte heslo", oneButtonTitle: "Rozumiem")
            return
        case (false, true, false, true, _):
            coordinator.showAlertOneButton(title: "Zadajte heslo znovu", oneButtonTitle: "Rozumiem")
            return
        case (false, true, false, false, false):
            coordinator.showAlertOneButton(title: "Heslá se nezhodujú", oneButtonTitle: "Rozumiem")
            return
        default:
            break
        }
        guard let email = email, let password = password else {
            return
        }
        viewController?.setLoading(enabled: true)

        switch inputData.mode {
        case .signup:
            firUserService.createUser(email: email, password: password) { [weak self] error in
                if error == nil {
                    self?.inputData.delegate?.updateUserState()
                    self?.discardButtonTapped()
                } else {
                    self?.viewController?.setLoading(enabled: false)
                    self?.coordinator.showAlertOneButton(title: "Chyba", message: error?.localizedDescription, oneButtonTitle: "Rozumiem", oneButtonAction: nil)
                }
            }
        case .login:
            firUserService.signIn(email: email, pass: password) { [weak self] error in
                if error == nil {
                    self?.inputData.delegate?.updateUserState()
                    self?.discardButtonTapped()
                } else {
                    self?.viewController?.setLoading(enabled: false)
                    self?.coordinator.showAlertOneButton(title: "Chyba", message: error?.localizedDescription, oneButtonTitle: "Rozumiem", oneButtonAction: nil)
                }
            }
        case .forgotPassword:
            firUserService.resetPasswordForEmail(email: email) { [weak self] error in
                if error == nil {
                    self?.coordinator.showAlertOneButton(
                        title: "",
                        message: nil,
                        oneButtonTitle: "Prejsť do e-mailu",
                        oneButtonAction: { [weak self] in
                            self?.discardButtonTapped()
                        }
                    )
                } else {
                    self?.viewController?.setLoading(enabled: false)
                    self?.coordinator.showAlertOneButton(title: "Chyba", message: error?.localizedDescription, oneButtonTitle: "Rozumiem", oneButtonAction: nil)
                }
            }
        }
    }

    func discardButtonTapped() {
        coordinator.stop(outputData: nil, completionAction: nil)
    }

    // MARK: - Utilities

    private func updateLayoutForCurrentMode() {
        viewController?.setupLayout(for: inputData.mode)
    }
}
