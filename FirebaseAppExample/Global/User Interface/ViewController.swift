//
//  ViewController.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Lifecycle
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        removeKeyboardObservers()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupKeyboardObservers()
    }
    
    // MARK: - Notifications

    func setupKeyboardObservers() {
        let center: NotificationCenter = .default
        center.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func removeKeyboardObservers() {
        let center: NotificationCenter = .default
        center.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        center.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // MARK: - Actions
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    // MARK: - Utilities
    
    @objc
    func keyboardWillChange(_ notification: Notification) {
        // Should be overriden
    }

    func duration(from userInfo: [AnyHashable: Any]) -> Double {
        return userInfo[UIResponder.keyboardAnimationDurationUserInfoKey]
            .flatMap { $0 as? NSNumber }
            .map { $0.doubleValue } ?? 0.0
    }

    func options(from userInfo: [AnyHashable: Any]) -> UIView.AnimationOptions {
        return userInfo[UIResponder.keyboardAnimationCurveUserInfoKey]
            .flatMap { $0 as? NSNumber }
            .map { $0.uintValue << 16 }
            .map(UIView.AnimationOptions.init) ?? UIView.AnimationOptions()
    }

    var inset: CGFloat {
        view.window?.safeAreaInsets.bottom ?? 0
    }

    func height(for userInfo: [AnyHashable: Any]) -> CGFloat {
        userInfo[UIResponder.keyboardFrameEndUserInfoKey]
            .flatMap { $0 as? NSValue }
            .map { $0.cgRectValue.height } ?? 0
    }
}
