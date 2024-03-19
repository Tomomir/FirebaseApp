//
//  TouchEngine.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

public protocol Touchable: AnyObject {
    var touchEngine: TouchEngine { get }
    var touchTargetView: UIView { get }
}

public class TouchEngine: NSObject {

    weak var delegate: Touchable? {
        didSet {
            if !gesturesCreated {
                createGestures()
            }
        }
    }

    // MARK: - Setupable properties

    public var shouldRecognizeSimultaneouslyWithOtherGestureRecognizers: Bool = true
    public var shouldStayHighlightedWhenTapped: Bool = false
    public var transformValue: CGFloat = 0.97

    // MARK: - Properties

    public var isHighlightingEnabled: Bool = true
    public var isActionEnabled: Bool = true
    public var isEnabled: Bool = true {
        didSet {
            isHighlightingEnabled = isEnabled
            isActionEnabled = isEnabled
        }
    }

    private var gesturesCreated: Bool = false
    private var quickPress: UILongPressGestureRecognizer!
    private var tap: UITapGestureRecognizer!

    private var isTapInProgress: Bool = false {
        didSet {
            guard isHighlightingEnabled else {
                return
            }
            if isTapInProgress != oldValue {
                if isTapInProgress {
                    highlight()
                } else {
                    if isHighlightFinished {
                        unhighlight()
                    } else {
                        isUnhighlightNeeded = true
                    }
                }
            }
        }
    }

    private var isHighlightFinished: Bool = false
    private var isUnhighlightNeeded: Bool = false

    public var customHighlightAction: Action?
    public var customUnhighlightAction: Action?
    public var customHighlightAnimationBlock: Action?
    public var customUnhighlightAnimationBlock: Action?

    public var action: Action?

    // MARK: - Create

    private func createGestures() {
        quickPress = UILongPressGestureRecognizer(target: self, action: #selector(handleQuickPress))
        quickPress.minimumPressDuration = 0.1
        quickPress.cancelsTouchesInView = false
        quickPress.delegate = self
        delegate?.touchTargetView.addGestureRecognizer(quickPress)

        tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        delegate?.touchTargetView.addGestureRecognizer(tap)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        pan.cancelsTouchesInView = true
        pan.delegate = self
        delegate?.touchTargetView.addGestureRecognizer(pan)
    }

    // MARK: - Setup

    @objc private func handleQuickPress(_ recognizer: UILongPressGestureRecognizer) {
        let location = recognizer.location(in: delegate?.touchTargetView)

        switch recognizer.state {
        case .began:
            cancelTap()
            isTapInProgress = true
        case .changed:
            isTapInProgress = delegate?.touchTargetView.bounds.contains(location) ?? false
        case .cancelled:
            isTapInProgress = false
        case .failed:
            isTapInProgress = false
        case .ended:
            if !shouldStayHighlightedWhenTapped {
                isTapInProgress = false
            }
            if delegate?.touchTargetView.bounds.contains(location) ?? false, isActionEnabled {
                action?()
            }
        default:
            break
        }
    }

    @objc private func handleTap(_ recognizer: UITapGestureRecognizer) {
        guard !isTapInProgress else {
            return
        }
        isTapInProgress = true
        if !shouldStayHighlightedWhenTapped {
            isTapInProgress = false
        }
        if isActionEnabled {
            action?()
        }
    }

    @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let velocity = recognizer.velocity(in: delegate?.touchTargetView)
        if abs(velocity.y) >= 1.5 * abs(velocity.x) {
            cancelGestures()
        }
    }

    // MARK: - Actions

    func reset() {
        isTapInProgress = false
    }

//    func resetWithoutAnimation() {
//        isEnabled = false
//        isTapInProgress = false
//        isEnabled = true
//    }

    func fakeTouch() {
        isUnhighlightNeeded = true
        highlight()
    }

    // MARK: - Utilities

    func cancelGestures() {
        cancelQuickPress()
        cancelTap()
    }

    private func cancelQuickPress() {
        quickPress.isEnabled = false
        quickPress.isEnabled = true
    }

    private func cancelTap() {
        tap.isEnabled = false
        tap.isEnabled = true
    }

    private func highlight() {
        if let customHighlightAction = customHighlightAction {
            customHighlightAction()
        } else {
            self.isHighlightFinished = false
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                if let customHighlightAnimationBlock = self.customHighlightAnimationBlock {
                    customHighlightAnimationBlock()
                } else {
                    self.delegate?.touchTargetView.transform = CGAffineTransform(scaleX: self.transformValue, y: self.transformValue)
                }
            }) { _ in
                self.isHighlightFinished = true

                if self.isUnhighlightNeeded {
                    self.isUnhighlightNeeded = false
                    self.unhighlight()
                }
            }
        }
    }

    private func unhighlight() {
        if let customUnhighlightAction = customUnhighlightAction {
            customUnhighlightAction()
        } else {
            UIView.animate(withDuration: 0.15, delay: 0.05, options: .curveEaseOut, animations: {
                if let customUnhighlightAnimationBlock = self.customUnhighlightAnimationBlock {
                    customUnhighlightAnimationBlock()
                } else {
                    self.delegate?.touchTargetView.transform = .identity
                }
            })
        }
    }
}

extension TouchEngine: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return shouldRecognizeSimultaneouslyWithOtherGestureRecognizers
    }
}

public class TouchableView: UIView, Touchable {

    // MARK: - Properties

    public var touchEngine = TouchEngine()
    public var touchTargetView: UIView { return self }

    // MARK: - Lifecycle

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        touchEngine.delegate = self
    }
}

public class TouchableImageView: UIImageView, Touchable {

    // MARK: - Properties

    public var touchEngine = TouchEngine()
    public var touchTargetView: UIView { return self }

    // MARK: - Lifecycle

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        touchEngine.delegate = self
    }
}

public class TouchableButton: UIButton, Touchable {

    // MARK: - Properties

    public var touchEngine = TouchEngine()
    public var touchTargetView: UIView { return self }

    // MARK: - Lifecycle

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        touchEngine.delegate = self
    }
}

public class TouchableLabel: UILabel, Touchable {

    // MARK: - Properties

    public var touchEngine = TouchEngine()
    public var touchTargetView: UIView { return self }

    // MARK: - Lifecycle

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        touchEngine.delegate = self
    }
}
