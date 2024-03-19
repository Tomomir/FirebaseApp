//
//  Coordinator.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

public typealias Coordinator<InputDataType, OutputDataType> = CoordinatorProtocol & CoordinatorSuperclass<InputDataType, OutputDataType>
public typealias Action = () -> Void

/// CoordinatorType
///
/// - replaceWindow: Replaces content in Window with NavigationController with new ViewController.
/// - push: Presents new ViewController with push transition - NavigationController as value is required.
/// - modal: Presents new ViewController with modal transition - SourceViewController as value is required.
public enum CoordinatorType {
    case replaceWindow(UIWindow?)
    case modal(UIViewController?)
    case push(UINavigationController?)
}

/// CoordinatorProtocol describes the most important properties and functions that has to be implemented by every Coordinator.
///
/// All properties should be stored in ParentCoordinator, from wich every specific Coordinator inherits.
/// Function start() should be implemented manually in specific Coordinator and it should create ViewController and ViewModel specific for that story and after that call function present().
/// Function finish(outputData) is already implemented.
public protocol CoordinatorProtocol {
    associatedtype InputDataType
    associatedtype OutputDataType

    var type: CoordinatorType { get }
    var inputData: InputDataType { get }
    var completion: ((OutputDataType) -> Void)? { get }

    func start()
    func stop(animated: Bool, outputData: OutputDataType, completionAction: Action?)
}

extension CoordinatorProtocol {
    public func stop(animated: Bool = true, outputData: OutputDataType, completionAction: Action?) {
        switch type {
        case .modal(let sourceViewController):
            if let sourceViewController = sourceViewController {
                sourceViewController.dismiss(animated: animated, completion: {
                    self.completion?(outputData)
                    completionAction?()
                })
            } else {
                assertionFailure("ViewController is missing.")
            }
        case .push(let navigationController):
            navigationController?.popViewController(animated: animated)
            completion?(outputData)
            completionAction?()
        default:
            assertionFailure("CoordinatorType [\(type)] does not have implemented finish method.")
        }
    }
}

/// ParentCoordinator class from wich every Coordinator should inherit.
/// It takes <InputDataType, OutputDataType> that declares types of input and output data.
open class CoordinatorSuperclass<InputDataType, OutputDataType> {

    // MARK: - Properties

    open var type: CoordinatorType
    open var inputData: InputDataType
    open var completion: ((OutputDataType) -> Void)?

    public weak var destinationNavigationController: UINavigationController?
    public weak var viewController: UIViewController?

    // MARK: - Init

    public init(
        type: CoordinatorType,
        inputData: InputDataType,
        completion: ((OutputDataType) -> Void)? = nil
    ) {
        self.type = type
        self.inputData = inputData
        self.completion = completion
    }

    // MARK: - Lifecycle

    open func presentByReplaceWindow(destinationNavigationController: UINavigationController? = nil, viewController: UIViewController?, animated: Bool = true) {
        guard let viewController = viewController else {
            assertionFailure("You passed nil value instead of viewController to method presentByReplaceWindow().")
            return
        }
        if case .replaceWindow(let window) = type {
            if let window = window {
                var destinationNavigationController = destinationNavigationController
                if destinationNavigationController == nil {
                    destinationNavigationController = UINavigationController(rootViewController: viewController)
                }
                if animated {
                    UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                        let oldState = UIView.areAnimationsEnabled
                        UIView.setAnimationsEnabled(false)
                        window.rootViewController = destinationNavigationController
                        UIView.setAnimationsEnabled(oldState)
                    })
                } else {
                    window.rootViewController = destinationNavigationController
                }
                self.destinationNavigationController = destinationNavigationController
                self.viewController = viewController
            } else {
                assertionFailure("You are trying to present story by replaceWindow, but window is missing, check if it was passed to init of Coordinator.")
            }
        } else {
            assertionFailure("You are trying to present story by replaceWindow, but you didnt initialized its Coordinator as replaceWindow.")
        }
    }

    open func presentByModal(destinationNavigationController: UINavigationController? = nil, viewController: UIViewController?, animated: Bool = true, completion: Action? = nil) {
        guard let viewController = viewController else {
            assertionFailure("You passed nil value instead of viewController to method presentByModal()")
            return
        }
        if case .modal(let sourceViewController) = type {
            if let sourceViewController = sourceViewController {
                if let destinationNavigationController = destinationNavigationController {
                    sourceViewController.present(destinationNavigationController, animated: animated, completion: completion)
                    self.destinationNavigationController = destinationNavigationController
                } else {
                    sourceViewController.present(viewController, animated: animated, completion: completion)
                }
                self.viewController = viewController
            } else {
                assertionFailure("You are trying to present story by modal, but sourceViewController is missing, check if it was passed to init of Coordinator.")
            }
        } else {
            assertionFailure("You are trying to present story by modal, but you didnt initialized its Coordinator as modal.")
        }
    }

    open func presentByPush(_ viewController: UIViewController?, animated: Bool = true) {
        guard let viewController = viewController else {
            assertionFailure("You passed nil value instead of viewController to method presentByPush()")
            return
        }
        if case .push(let navigationController) = type {
            if let navigationController = navigationController {
                navigationController.pushViewController(viewController, animated: animated)
                self.viewController = viewController
            } else {
                assertionFailure("You are trying to present story by push, but you didnt pass NavigationController at initialization of its Coordinator.")
            }
        } else {
            assertionFailure("You are trying to present story by push, but you didnt initialized its Coordinator as push.")
        }
    }

    // MARK: - Helpers

    var window: UIWindow? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.coordinator?.window
    }

    var navigationController: UINavigationController? {
        switch type {
        case .replaceWindow, .modal:
            return destinationNavigationController
        case .push(let navigationController):
            return navigationController
        }
    }
}

