//
//  UIView+Extensions.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

extension UIView {

    // MARK: - Properties

    public static var nibName: String {
        return String(describing: self)
    }

    // MARK: - Constraints

    public func addSubview(_ view: UIView?, constraints: [NSLayoutConstraint]) {
        guard let view = view else {
            return
        }
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }

    public func addSubviewWithConstraintsToEdges(_ view: UIView?) {
        guard let view = view else {
            return
        }
        addSubview(view, constraints: [
            view.topAnchor.constraint(equalTo: topAnchor),
            view.rightAnchor.constraint(equalTo: rightAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leftAnchor.constraint(equalTo: leftAnchor)
        ])
    }

    public func addSubviewWithConstraintsToCenter(_ view: UIView?) {
        guard let view = view else {
            return
        }
        addSubview(view, constraints: [
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    public func addConstraints(height: CGFloat, width: CGFloat) {
        addConstraint(height: height)
        addConstraint(width: width)
    }

    public func addConstraint(height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: height)
        ])
    }

    public func addConstraint(width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width)
        ])
    }

    // MARK: - Animations

    public func startPulseAnimation(fromAlpha: CGFloat, toAlpha: CGFloat, duration: TimeInterval) {
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = duration
        pulseAnimation.fromValue = fromAlpha
        pulseAnimation.toValue = toAlpha
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .greatestFiniteMagnitude
        layer.add(pulseAnimation, forKey: nil)
    }

    func shakeAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }

    // MARK: - Other

//    var snapshot: UIImage {
//        return UIGraphicsImageRenderer(size: bounds.size).image { _ in
//            drawHierarchy(in: bounds, afterScreenUpdates: false)
//        }
//    }

    var snapshot: UIImage? {
        var image: UIImage?
        UIGraphicsBeginImageContextWithOptions(frame.size, true, 1)
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
}
