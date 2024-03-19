//
//  Coordinator+Alerts.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

extension CoordinatorSuperclass {
    public func showAlertOneButton(title: String? = nil, message: String? = nil, oneButtonTitle: String = "Rozumiem", oneButtonAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let oneButtonAction = UIAlertAction(
            title: oneButtonTitle,
            style: .default,
            handler: { _ in oneButtonAction?() }
        )
        alert.addAction(oneButtonAction)

        viewController?.present(alert, animated: true, completion: nil)
    }

    public func showAlertCancelOrAction(title: String? = nil, message: String? = nil, actionButtonTitle: String, actionButtonAction: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("Nie", comment: "No"),
            style: .default,
            handler: nil
        )
        let actionAction = UIAlertAction(
            title: actionButtonTitle,
            style: .destructive,
            handler: { _ in actionButtonAction() }
        )
        alert.addAction(cancelAction)
        alert.addAction(actionAction)

        viewController?.present(alert, animated: true, completion: nil)
    }

    public func showAlertCustom(title: String? = nil, message: String? = nil, actions: [UIAlertAction], style: UIAlertController.Style = .alert) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        actions.forEach { alert.addAction($0) }
        viewController?.present(alert, animated: true, completion: nil)
    }
}
