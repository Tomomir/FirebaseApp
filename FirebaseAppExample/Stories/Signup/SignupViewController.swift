//
//  SignupViewController.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

protocol SignupViewControllerActions: AnyObject {
    func setupLayout(for mode: SignupViewModel.Mode)
    func setLoading(enabled: Bool)
}

final class SignupViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet private weak var cardView: UIView!

    @IBOutlet private weak var titleLabel: UILabel!

    @IBOutlet private weak var stackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var emailTextFieldClearTouchableView: TouchableView!

    @IBOutlet private weak var emailAndPasswordSpacingView: UIView!

    @IBOutlet private weak var passwordTextFieldHolderView: UIView!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordTextFieldVisibilityTouchableView: TouchableView!
    @IBOutlet private weak var passwordTextFieldVisibilityImageView: UIImageView!

    @IBOutlet private weak var passwordAndPasswordAgainSpacingView: UIView!

    @IBOutlet private weak var passwordAgainTextFieldHolderView: UIView!
    @IBOutlet private weak var passwordAgainTextField: UITextField!
    @IBOutlet private weak var passwordAgainTextFieldVisibilityTouchableView: TouchableView!
    @IBOutlet private weak var passwordAgainTextFieldVisibilityImageView: UIImageView!

    @IBOutlet private weak var passwordAgainAndForgotPasswordSpacingView: UIView!

    @IBOutlet private weak var forgotPasswordHolderView: UIView!
    @IBOutlet private weak var forgotPasswordButtonTouchableView: TouchableView!

    @IBOutlet private weak var primaryButtonTouchableView: TouchableView!
    @IBOutlet private weak var primaryButtonView: LoadingView!
    @IBOutlet private weak var primaryButtonBottomLayoutConstraint: NSLayoutConstraint!

    // MARK: - Properties

    var viewModel: SignupViewModel!
    private var isKeyboardHidden: Bool = true

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupInteractions()
        setupTextFields()

        viewModel.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        removeKeyboardObservers()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupKeyboardObservers()
    }

    // MARK: - Setup

    private func setupLayout() {
    
    }

    private func setupTextFields() {
        // Email
        let placeholder: String = "E-mail"
        emailTextField.attributedPlaceholder = placeholder.attributed(.textInputPlaceholder)
        emailTextField.setup(textStyle: .textInput)

        // Password
        let passwordPlaceholder: String = "Heslo (8-20 znaků)"
        passwordTextField.attributedPlaceholder = passwordPlaceholder.attributed(.textInputPlaceholder)
        passwordTextField.setup(textStyle: .textInput)

        // Password again
        let passwordAgainPlaceholder: String = "Heslo znovu"
        passwordAgainTextField.attributedPlaceholder = passwordAgainPlaceholder.attributed(.textInputPlaceholder)
        passwordAgainTextField.setup(textStyle: .textInput)
    }

    private func setupInteractions() {
        let cardViewTap = UITapGestureRecognizer(target: self, action: #selector(handleCardViewTap(_:)))
        cardView.addGestureRecognizer(cardViewTap)

        emailTextFieldClearTouchableView.touchEngine.action = { [weak self] in
            self?.emailTextField.text = ""
            self?.viewModel.email = ""
            self?.updateEmailTextFieldClearButton()
        }
        passwordTextFieldVisibilityTouchableView.touchEngine.shouldRecognizeSimultaneouslyWithOtherGestureRecognizers = false
        passwordTextFieldVisibilityTouchableView.touchEngine.action = { [weak self] in
            self?.togglePasswordTextFieldVisibility()
        }
        passwordAgainTextFieldVisibilityTouchableView.touchEngine.shouldRecognizeSimultaneouslyWithOtherGestureRecognizers = false
        passwordAgainTextFieldVisibilityTouchableView.touchEngine.action = { [weak self] in
            self?.togglePasswordAgainTextFieldVisibility()
        }

        forgotPasswordButtonTouchableView.touchEngine.action = { [weak self] in
            self?.viewModel.forgotPasswordButtonTapped()
        }

        primaryButtonTouchableView.touchEngine.action = { [weak self] in
            self?.viewModel.primaryButtonTapped()
        }
    }

    // MARK: - Actions

    @IBAction private func emailTextFieldEditingChanged(_ sender: Any) {
        viewModel.email = emailTextField.text
        updateEmailTextFieldClearButton()
    }

    @IBAction private func emailTextFieldPrimaryActionTriggered(_ sender: Any) {
        emailTextField.resignFirstResponder()
        passwordTextField.becomeFirstResponder()
    }

    @IBAction private func passwordTextFieldEditingChanged(_ sender: Any) {
        viewModel.password = passwordTextField.text
    }

    @IBAction private func passwordTextFieldPrimaryActionTriggered(_ sender: Any) {
        passwordTextField.resignFirstResponder()
        if !viewModel.isModeLogin {
            passwordAgainTextField.becomeFirstResponder()
        }
    }

    @IBAction private func passwordAgainTextFieldEditingChanged(_ sender: Any) {
        viewModel.passwordAgain = passwordAgainTextField.text
    }

    @IBAction private func passwordAgainTextFieldPrimaryActionTriggered(_ sender: Any) {
        passwordAgainTextField.resignFirstResponder()
    }

    // MARK: - Utilities

    private func togglePasswordTextFieldVisibility() {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        passwordTextFieldVisibilityImageView.image = passwordTextField.isSecureTextEntry ? UIImage(named: "icShow") : UIImage(named: "icHide")
    }

    private func togglePasswordAgainTextFieldVisibility() {
        passwordAgainTextField.isSecureTextEntry = !passwordAgainTextField.isSecureTextEntry
        passwordAgainTextFieldVisibilityImageView.image = passwordAgainTextField.isSecureTextEntry ? UIImage(named: "icShow") : UIImage(named: "icHide")
    }

    private func updateEmailTextFieldClearButton() {
        emailTextFieldClearTouchableView.isHidden = emailTextField.text?.isEmpty ?? true
    }
    
    @objc private func handleTap() {
        if isKeyboardHidden {
            viewModel.discardButtonTapped()
        } else {
            view.endEditing(true)
        }
    }

    @objc private func handleCardViewTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let tapLocation = gestureRecognizer.location(in: cardView)
        let tappedView = cardView.hitTest(tapLocation, with: nil)
        
        if tappedView === emailTextFieldClearTouchableView ||
        tappedView === passwordAgainTextFieldVisibilityTouchableView {
            return
        }
        
        if !isKeyboardHidden {
            view.endEditing(true)
        }
    }

    // MARK: - Utilities: Keyboard

    private func setupKeyboardObservers() {
        let center: NotificationCenter = .default
        center.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    private func removeKeyboardObservers() {
        let center: NotificationCenter = .default
        center.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        center.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    @objc
    private func keyboardWillChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        let isHiding = (notification.name == UIResponder.keyboardWillHideNotification)
        isKeyboardHidden = isHiding

        UIView.animate(withDuration: duration(from: userInfo), delay: 0, options: options(from: userInfo)) {
            self.primaryButtonBottomLayoutConstraint.constant = isHiding
                ? (self.viewModel.isModeLogin ? 30 : 30)
                : self.height(for: userInfo) - self.inset + 10
            self.stackViewTopConstraint.constant = isHiding ? 50 : 20
            //self.stackViewBottomConstraint.constant = isHiding ? 45 : 15
            self.view.layoutIfNeeded()
        } completion: { _ in

        }
    }

    private func duration(from userInfo: [AnyHashable: Any]) -> Double {
        return userInfo[UIResponder.keyboardAnimationDurationUserInfoKey]
            .flatMap { $0 as? NSNumber }
            .map { $0.doubleValue } ?? 0.0
    }

    private func options(from userInfo: [AnyHashable: Any]) -> UIView.AnimationOptions {
        return userInfo[UIResponder.keyboardAnimationCurveUserInfoKey]
            .flatMap { $0 as? NSNumber }
            .map { $0.uintValue << 16 }
            .map(UIView.AnimationOptions.init) ?? UIView.AnimationOptions()
    }

    private var inset: CGFloat {
        view.window?.safeAreaInsets.bottom ?? 0
    }

    private func height(for userInfo: [AnyHashable: Any]) -> CGFloat {
        userInfo[UIResponder.keyboardFrameEndUserInfoKey]
            .flatMap { $0 as? NSValue }
            .map { $0.cgRectValue.height } ?? 0
    }
}

extension SignupViewController: SignupViewControllerActions {
    func setupLayout(for mode: SignupViewModel.Mode) {
        titleLabel.text = viewModel.mode.title
        passwordTextField.attributedPlaceholder = (viewModel.isModeLogin ? "Heslo" : "Heslo (8-20 znakov)" ).attributed(.textInputPlaceholder)

        // Email
        emailTextField.returnKeyType = viewModel.isModeForgotPassword ? .done : .next

        // spacing
        emailAndPasswordSpacingView.isHidden = viewModel.isModeForgotPassword

        // Password
        passwordTextFieldHolderView.isHidden = viewModel.isModeForgotPassword
        passwordTextField.returnKeyType = viewModel.isModeLogin ? .done : .next

        // spacing
        passwordAndPasswordAgainSpacingView.isHidden = viewModel.isModeLogin || viewModel.isModeForgotPassword

        // Password again
        passwordAgainTextFieldHolderView.isHidden = viewModel.isModeLogin || viewModel.isModeForgotPassword

        // spacing
        passwordAgainAndForgotPasswordSpacingView.isHidden = !viewModel.isModeLogin

        // Forgot password
        forgotPasswordHolderView.isHidden = !viewModel.isModeLogin

        primaryButtonView.title = viewModel.mode.primaryButtonTitle
    }

    func setLoading(enabled: Bool) {
        navigationController?.presentationController?.presentedView?.gestureRecognizers?.forEach {
            $0.isEnabled = !enabled
        }
        view.isUserInteractionEnabled = !enabled
        primaryButtonView.setLoading(enabled: enabled)
    }
}
