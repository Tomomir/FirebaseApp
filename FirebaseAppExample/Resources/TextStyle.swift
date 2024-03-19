//
//  TextStyle.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

struct TextStyle {
    // MARK: - Properties

    let font: UIFont
    let colorKey: ColorKey
    let alignment: NSTextAlignment
    let linespacing: CGFloat?
    let lineHeight: CGFloat
    let underlined: Bool
    let subscripted: Bool
    let superscripted: Bool
    let kerning: CGFloat // == letter spacing
    let lineBreakMode: NSLineBreakMode
    let lineLimit: Int

    // MARK: - Init

    init(font: UIFont, colorKey: ColorKey, alignment: NSTextAlignment = .left, linespacing: CGFloat? = nil, lineHeight: CGFloat = 0.0, underlined: Bool = false, subscripted: Bool = false, superscripted: Bool = false, kerning: CGFloat = 0.0, lineBreakMode: NSLineBreakMode = .byWordWrapping, lineLimit: Int = 0) {
        self.font = font
        self.colorKey = colorKey
        self.alignment = alignment
        self.linespacing = linespacing
        self.lineHeight = lineHeight
        self.underlined = underlined
        self.subscripted = subscripted
        self.superscripted = superscripted
        self.kerning = kerning
        self.lineBreakMode = lineBreakMode
        self.lineLimit = lineLimit
    }

    // MARK: - Helpers

    private var paragraphStyle: NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.lineBreakMode = lineBreakMode

        // Use either line height, or line spacing.
        // Line height has higher prio.
        if lineHeight > 0 {
            paragraphStyle.maximumLineHeight = lineHeight
            // Hack for underlined texts: heightOfLabel does not count the underline
            // into the resulted bounding rect.
            // TODO: Although correct setting of this parameter, it breaks some UI parts of application -- needs more investigation.
            // paragraphStyle.minimumLineHeight = lineHeight - (underlined ? 1 : 0)
        } else if let linespacing = linespacing {
            paragraphStyle.lineSpacing = linespacing
        }
        return paragraphStyle
    }

    // MARK: - Resources

    var attributes: [NSAttributedString.Key: Any] {
        var ret: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: ThemeManager.shared.color(for: colorKey),
            .paragraphStyle: paragraphStyle,
        ]

        if underlined {
            ret[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        ret[.kern] = kerning

        if subscripted {
            ret[.baselineOffset] = -font.pointSize / 3
        }

        if superscripted {
            ret[.baselineOffset] = font.pointSize / 3
        }

        if lineHeight > 0 {
            // TODO: Explore all consequences!
//            ret[.baselineOffset] = (lineHeight - font.pointSize) / 2 / 2
        }

        return ret
    }
}

// MARK: - Helpers

extension String {
    func attributed(_ style: TextStyle) -> NSMutableAttributedString {
        NSMutableAttributedString(string: self, attributes: style.attributes)
    }
}

extension NSMutableAttributedString {
    func attributed(_ style: TextStyle) -> NSMutableAttributedString {
        let ret = NSMutableAttributedString(attributedString: self)
        ret.addAttributes(style.attributes, range: NSRange(location: 0, length: length))
        return ret
    }
}

extension UIFont {
    var scalable: UIFont {
        let scale = FontManager.shared.currentScale
        return UIFont(descriptor: fontDescriptor, size: pointSize * scale)
    }

    func limitedScalable(limit: CGFloat) -> UIFont {
        let scale = FontManager.shared.currentScale
        return UIFont(descriptor: fontDescriptor, size: min(limit, pointSize * scale))
    }
}

extension TextStyle {
    /// Returns lineHeight for scalable font.
    func scalableLineHeight(scale: CGFloat) -> CGFloat {
        lineHeight * scale
    }

    /// Returns lineHeight for scalable font with defined limit.
    func scalableLimitLineHeight(scale: CGFloat, limit: CGFloat) -> CGFloat {
        min(limit * (lineHeight / font.pointSize), lineHeight * scale)
    }

    var withScalableFont: TextStyle {
        TextStyle(font: font.scalable, colorKey: colorKey, alignment: alignment, linespacing: linespacing, lineHeight: scalableLineHeight(scale: FontManager.shared.currentScale), underlined: underlined, subscripted: subscripted, superscripted: superscripted, kerning: kerning, lineBreakMode: lineBreakMode, lineLimit: lineLimit)
    }

    func withLimitedScalableFont(limit: CGFloat) -> TextStyle {
        TextStyle(font: font.limitedScalable(limit: limit), colorKey: colorKey, alignment: alignment, linespacing: linespacing, lineHeight: scalableLimitLineHeight(scale: FontManager.shared.currentScale, limit: limit), underlined: underlined, subscripted: subscripted, superscripted: superscripted, kerning: kerning, lineBreakMode: lineBreakMode, lineLimit: lineLimit)
    }
}

// MARK: - Components

extension UILabel {
    func setup(textStyle: TextStyle, newText: String? = nil) {
        saveThemable(textStyle: textStyle)
        if let newText = newText {
            attributedText = newText.attributed(textStyle)
        } else {
            attributedText = text?.attributed(textStyle)
        }
    }
}

extension UITextView {
    func setup(textStyle: TextStyle, newText: String? = nil) {
        if let newText = newText {
            attributedText = newText.attributed(textStyle)
        } else {
            attributedText = text.attributed(textStyle)
        }
        typingAttributes = textStyle.attributes
    }

    func setup(textStyle: TextStyle, newText: NSAttributedString? = nil) {
        if let newText = newText?.mutableCopy() as? NSMutableAttributedString {
            attributedText = newText.attributed(textStyle)
        } else {
            attributedText = text.attributed(textStyle)
        }
        typingAttributes = textStyle.attributes
    }
}

extension UITextField {
    func setup(textStyle: TextStyle) {
        saveThemable(textStyle: textStyle)
        textColor = ThemeManager.shared.color(for: textStyle.colorKey)
        font = textStyle.font
    }
}

extension UIButton {
    func setup(textStyle: TextStyle) {
        titleLabel?.font = textStyle.font
        setTitleColor(ThemeManager.shared.color(for: textStyle.colorKey), for: .normal)
    }
}
