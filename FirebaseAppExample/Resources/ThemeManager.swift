//
//  ThemeManager.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

struct ThemableKeys {
    static var themableBackgroundColorKey = "themableBackgroundColor"
    static var themableTextStyleKey = "themableTextStyle"
    static var themableImageKey = "themableImage"
    static var themableImageTintColorKey = "themableImageTintColor"
    static var themableTitleColorKey = "themableTitleColor"
    static var themableTintColor = "themableTintColor"
    static var themableColor = "themableColor"
}

protocol Theme: AnyObject {
    func color(for colorKey: ColorKey) -> UIColor
    func image(for imageKey: ImageKey) -> UIImage
}

final class ThemeManager {

    // MARK: - Static

    static let shared: ThemeManager = ThemeManager()
    static let themeDidChange = Notification.Name("themeDidChange")

    // MARK: - Properties

    private let keyTheme = "keyTheme"

    var currentTheme: ThemeKey {
        get {
            return ThemeKey(rawValue: UserDefaults.standard.string(forKey: keyTheme) ?? ThemeKey.light.rawValue) ?? .light
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: keyTheme)
        }
    }

    var currentThemeStatusBarStyle: UIStatusBarStyle {
        // on iOS 12 - .default means black statusbar, .lightContent white statusbar
        // since iOS 13, .default can be black or white according to system settings (especially in dark mode .default means white!)
        if #available(iOS 13.0, *) {
            return currentTheme == .light ? .darkContent : .lightContent
        } else {
            return currentTheme == .light ? .default : .lightContent
        }
    }

    // MARK: - Init

    private init() { } // Because ThemeManager is singleton and it should by used only by ThemeManager.shared

    // MARK: - Actions

    func changeTheme(to themeKey: ThemeKey) {
        let didChangeRapidly: Bool =
            (currentTheme == .dark && themeKey == .light)
            ||
            (currentTheme == .light && themeKey == .dark)

        currentTheme = themeKey
        NotificationCenter.default.post(name: ThemeManager.themeDidChange, object: nil, userInfo: ["didChangeRapidly": didChangeRapidly])
    }

    // MARK: - Utilities

    func color(for colorKey: ColorKey) -> UIColor {
        return currentTheme.value.color(for: colorKey)
    }

    func image(for imageKey: ImageKey) -> UIImage {
        return currentTheme.value.image(for: imageKey)
    }
}

// MARK: - Components

extension NSObject {
    func setupThemeDidChangeNotification(selector: Selector) {
        removeThemeDidChangeNotification()
        addThemeDidChangeNotification(selector: selector)
    }

    func removeThemeDidChangeNotification() {
        NotificationCenter.default.removeObserver(self, name: ThemeManager.themeDidChange, object: nil)
    }

    func addThemeDidChangeNotification(selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: ThemeManager.themeDidChange, object: nil)
    }
}

extension UIView {
    var themableBackgroundColor: ColorKey? {
        get {
            return objc_getAssociatedObject(self, ThemableKeys.themableBackgroundColorKey) as? ColorKey
        }
        set {
            if let newValue = newValue {
                backgroundColor = ThemeManager.shared.color(for: newValue)
                objc_setAssociatedObject(self, ThemableKeys.themableBackgroundColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                setupThemeDidChangeNotification(selector: #selector(reloadBackgroundColor))
            }
        }
    }

    @objc private func reloadBackgroundColor() {
        guard let themableBackgroundColor = themableBackgroundColor else {
            return
        }
        backgroundColor = ThemeManager.shared.color(for: themableBackgroundColor)
    }

    var themableTintColor: ColorKey? {
        get {
            return objc_getAssociatedObject(self, ThemableKeys.themableTintColor) as? ColorKey
        }
        set {
            if let newValue = newValue {
                tintColor = ThemeManager.shared.color(for: newValue)
                objc_setAssociatedObject(self, ThemableKeys.themableTintColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                setupThemeDidChangeNotification(selector: #selector(reloadTintColor))
            }
        }
    }

    @objc private func reloadTintColor() {
        guard let themableTintColor = themableTintColor else {
            return
        }
        tintColor = ThemeManager.shared.color(for: themableTintColor)
    }
}

extension UIRefreshControl {
//    var themableTintColor: ColorKey? {
//        get {
//            return objc_getAssociatedObject(self, &ThemableKeys.themableTintColor) as? ColorKey
//        }
//        set {
//            if let newValue = newValue {
//                tintColor = ThemeManager.shared.color(for: newValue)
//                objc_setAssociatedObject(self, &ThemableKeys.themableTintColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//                setupThemeDidChangeNotification(selector: #selector(reloadTintColor))
//            }
//        }
//    }
//
//    @objc private func reloadTintColor() {
//        guard let themableTintColor = themableTintColor else {
//            return
//        }
//        tintColor = ThemeManager.shared.color(for: themableTintColor)
//    }
}

extension UIActivityIndicatorView {
    var themableColor: ColorKey? {
        get {
            return objc_getAssociatedObject(self, ThemableKeys.themableTintColor) as? ColorKey
        }
        set {
            if let newValue = newValue {
                color = ThemeManager.shared.color(for: newValue)
                objc_setAssociatedObject(self, ThemableKeys.themableTintColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                setupThemeDidChangeNotification(selector: #selector(reloadColor))
            }
        }
    }

    @objc private func reloadColor() {
        guard let themableColor = themableColor else {
            return
        }
        color = ThemeManager.shared.color(for: themableColor)
    }
}

extension UIImageView {
    var themableImage: ImageKey? {
        get {
            return objc_getAssociatedObject(self, ThemableKeys.themableImageKey) as? ImageKey
        }
        set {
            if let newValue = newValue {
                image = ThemeManager.shared.image(for: newValue)
                objc_setAssociatedObject(self, ThemableKeys.themableImageKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                setupThemeDidChangeNotification(selector: #selector(reloadImage))
            }
        }
    }

    var themableImageTintColor: ColorKey? {
        get {
            return objc_getAssociatedObject(self, ThemableKeys.themableImageTintColorKey) as? ColorKey
        }
        set {
            if let newValue = newValue {
                tintColor = ThemeManager.shared.color(for: newValue)
                objc_setAssociatedObject(self, ThemableKeys.themableImageTintColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                setupThemeDidChangeNotification(selector: #selector(reloadImageTintColor))
            }
        }
    }

    @objc private func reloadImage() {
        guard let themableImage = themableImage else {
            return
        }
        image = ThemeManager.shared.image(for: themableImage)
    }

    @objc private func reloadImageTintColor() {
        guard let themableImageTintColor = themableImageTintColor else { return }
        tintColor = ThemeManager.shared.color(for: themableImageTintColor)
    }
}

extension UIButton {
    var themableImage: ImageKey? {
        get {
            return objc_getAssociatedObject(self, ThemableKeys.themableImageKey) as? ImageKey
        }
        set {
            if let newValue = newValue {
                setImage(ThemeManager.shared.image(for: newValue), for: .normal)
                objc_setAssociatedObject(self, ThemableKeys.themableImageKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                setupThemeDidChangeNotification(selector: #selector(reloadImage))
            }
        }
    }

    var themableTitleColor: ColorKey? {
        get {
            return objc_getAssociatedObject(self, ThemableKeys.themableTitleColorKey) as? ColorKey
        }
        set {
            if let newValue = newValue {
                setTitleColor(ThemeManager.shared.color(for: newValue), for: .normal)
                objc_setAssociatedObject(self, ThemableKeys.themableTitleColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                setupThemeDidChangeNotification(selector: #selector(reloadTitleColor))
            }
        }
    }

    @objc private func reloadImage() {
        guard let themableImage = themableImage else {
            return
        }
        setImage(ThemeManager.shared.image(for: themableImage), for: .normal)
    }

    @objc private func reloadTitleColor() {
        guard let themableTitleColor = themableTitleColor else {
            return
        }
        setTitleColor(ThemeManager.shared.color(for: themableTitleColor), for: .normal)
    }
}

extension UITextField {
    func saveThemable(textStyle: TextStyle) {
        objc_setAssociatedObject(self, ThemableKeys.themableTextStyleKey, textStyle, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        setupThemeDidChangeNotification(selector: #selector(reloadTextStyle))
    }

    @objc private func reloadTextStyle() {
        guard let textStyle = objc_getAssociatedObject(self, ThemableKeys.themableTextStyleKey) as? TextStyle else {
            return
        }
        setup(textStyle: textStyle)
    }
}

extension UILabel {
    func saveThemable(textStyle: TextStyle) {
        objc_setAssociatedObject(self, ThemableKeys.themableTextStyleKey, textStyle, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        setupThemeDidChangeNotification(selector: #selector(reloadTextStyle))
    }

    @objc private func reloadTextStyle() {
        guard let textStyle = objc_getAssociatedObject(self, ThemableKeys.themableTextStyleKey) as? TextStyle else {
            return
        }
        setup(textStyle: textStyle, newText: attributedText?.string ?? text ?? "")
    }
}
