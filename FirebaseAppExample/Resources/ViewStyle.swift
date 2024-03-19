//
//  ViewStyle.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

protocol ViewStylable {
    func setup(viewStyle: ViewStyle)

    func setup(shadowStyle: ShadowStyle?)
    func setup(borderStyle: BorderStyle?)
}

public struct ViewStyle {

    // MARK: - Properties

    let backgroundColor: UIColor?
    let cornerRadius: CGFloat?
    let borderStyle: BorderStyle?
    let shadowStyle: ShadowStyle?

    // MARK: - Init

    public init(backgroundColor: UIColor? = nil, cornerRadius: CGFloat? = nil, borderStyle: BorderStyle? = nil, shadowStyle: ShadowStyle? = nil) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.borderStyle = borderStyle
        self.shadowStyle = shadowStyle
    }
}

public struct ShadowStyle {

    // MARK: - Properties

    let color: UIColor
    let radius: CGFloat
    let offset: CGSize
    let opacity: Float

    // MARK: - Init

    public init(color: UIColor = .black, radius: CGFloat = 5, offset: CGSize = .zero, opacity: Float = 1) {
        self.color = color
        self.radius = radius
        self.offset = offset
        self.opacity = opacity
    }
}

public struct BorderStyle {

    // MARK: - Properties

    let color: UIColor
    let width: CGFloat

    // MARK: - Init

    public init(color: UIColor = .black, width: CGFloat = 1) {
        self.color = color
        self.width = width
    }
}

extension UIView: ViewStylable {
    public func setup(viewStyle: ViewStyle) {
        if let backgroundColor = viewStyle.backgroundColor {
            self.backgroundColor = backgroundColor
        }
        if let cornerRadius = viewStyle.cornerRadius {
            layer.cornerRadius = cornerRadius
        }
        if let shadowStyle = viewStyle.shadowStyle {
            setup(shadowStyle: shadowStyle)
        }
        if let borderStyle = viewStyle.borderStyle {
            setup(borderStyle: borderStyle)
        }
    }

    public func setup(cornerRadius: CGFloat?) {
        layer.cornerRadius = cornerRadius ?? 0
    }

    public func setup(shadowStyle: ShadowStyle?) {
        if let shadowStyle = shadowStyle {
            layer.shadowColor = shadowStyle.color.cgColor
            layer.shadowOffset = shadowStyle.offset
            layer.shadowRadius = shadowStyle.radius
            layer.shadowOpacity = shadowStyle.opacity
        } else {
            layer.shadowColor = nil
            layer.shadowOffset = CGSize(width: 0, height: -3)
            layer.shadowRadius = 3
            layer.shadowOpacity = 0
        }
    }

    public func setup(borderStyle: BorderStyle?) {
        if let borderStyle = borderStyle {
            layer.borderColor = borderStyle.color.cgColor
            layer.borderWidth = borderStyle.width
        } else {
            layer.borderColor = nil
            layer.borderWidth = 0
        }
    }
}
