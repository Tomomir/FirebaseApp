//
//  FontManager.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

final class FontManager {

    static let shared = FontManager()

    // MARK: - Types

    enum RespectMode {
        case system
        case application
    }

    // MARK: - Properties: Public

    static let appSizeDidChangeNotification = Notification.Name(rawValue: "inAppSizeDidChange")
    static let systemSizeDidChangeNotification = UIContentSizeCategory.didChangeNotification

    var currentSize: UIContentSizeCategory {
        switch respectMode {
        case .system:
            return currentSystemSize
        case .application:
            return savedApplicationSize
        }
    }

    var currentSizeIndex: Int {
        sizes.firstIndex(of: currentSize) ?? 0
    }

    var numberOfSizes: Int {
        sizes.count
    }

    var currentScale: CGFloat {
        sizeToScale[currentSize] ?? 1.0
    }

    var smallestSize: Float {
        Float(sizeToScale[.extraSmall] ?? 0.0)
    }

    var largestSize: Float {
        Float(sizeToScale[.accessibilityExtraExtraExtraLarge] ?? 1.5)
    }

    var allSizes: [CGFloat] {
        [CGFloat](sizeToScale.values)
    }

    // MARK: - Properties: Private

    private let vibrationID: UInt32 = 1519

    private let defaults = UserDefaults.standard
    private let keyLastSystemSize = "lastSystemSize"
    private let keyLastApplicationSize = "lastApplicationSize"
    private let keyRespectSystemSize = "respectSystemSize"

    private var sizes: [UIContentSizeCategory] = [
        .extraSmall,
        .small,
        .medium,
        .large,
        .extraLarge,
        .extraExtraLarge,
        .extraExtraExtraLarge,
        .accessibilityMedium,
        .accessibilityLarge,
        .accessibilityExtraLarge,
        .accessibilityExtraExtraLarge,
        .accessibilityExtraExtraExtraLarge,
    ]

    private let sizeToScale: [UIContentSizeCategory: CGFloat] = [
        .extraSmall: 0.7,
        .small: 0.8,
        .medium: 0.9,
        .large: 1,
        .extraLarge: 1.1,
        .extraExtraLarge: 1.2,
        .extraExtraExtraLarge: 1.3,
        .accessibilityMedium: 1.4,
        .accessibilityLarge: 1.5,
        .accessibilityExtraLarge: 1.6,
        .accessibilityExtraExtraLarge: 1.7,
        .accessibilityExtraExtraExtraLarge: 1.8,
    ]

    // MARK: - Init

    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(systemSizeDidChange), name: FontManager.systemSizeDidChangeNotification, object: nil)
    }

    // MARK: - Actions

    func changeSize(to index: Int, shouldRespectSystemSize: Bool) {
        let size = sizes[index]

        saveSystemSize()
        saveApplicationSize(size)
        self.shouldRespectSystemSize = shouldRespectSystemSize

        NotificationCenter.default.post(name: FontManager.appSizeDidChangeNotification, object: nil)
    }

    func changeSize(to size: CGFloat, shouldRespectSystemSize: Bool) {
        guard let size = sizeToContentSizeCategory(size: size) else { return }

        saveSystemSize()
        saveApplicationSize(size)
        self.shouldRespectSystemSize = shouldRespectSystemSize

        NotificationCenter.default.post(name: FontManager.appSizeDidChangeNotification, object: nil)
    }

    // MARK: - Utilities

    var respectMode: RespectMode {
//        if currentSystemSize != savedSystemSize {
//            return .system
//        } else {
//            return shouldRespectSystemSize ? .system : .application
//        }

        return shouldRespectSystemSize ? .system : .application
    }

    private var currentSystemSize: UIContentSizeCategory {
        UIApplication.shared.preferredContentSizeCategory
    }

    @objc
    private func systemSizeDidChange() {
        saveSystemSize()
    }

    // MARK: - Saved values

    private var savedSystemSize: UIContentSizeCategory {
        get {
            UIContentSizeCategory(rawValue: defaults.string(forKey: keyLastSystemSize) ?? currentSystemSize.rawValue)
        }
        set {
            defaults.set(newValue.rawValue, forKey: keyLastSystemSize)
        }
    }

    private var savedApplicationSize: UIContentSizeCategory {
        get {
            UIContentSizeCategory(rawValue: defaults.string(forKey: keyLastApplicationSize) ?? currentSystemSize.rawValue)
        }
        set {
            defaults.set(newValue.rawValue, forKey: keyLastApplicationSize)
        }
    }

    private var shouldRespectSystemSize: Bool {
        get {
            defaults.bool(forKey: keyRespectSystemSize)
        }
        set {
            defaults.set(newValue, forKey: keyRespectSystemSize)
        }
    }

    // MARK: - Helpers

    private func saveSystemSize() {
        savedSystemSize = currentSystemSize
    }

    private func saveApplicationSize(_ size: UIContentSizeCategory) {
        savedApplicationSize = size
    }

    private func sizeToContentSizeCategory(size: CGFloat) -> UIContentSizeCategory? {
        // map value to key
        if let key = sizeToScale.first(where: { $0.value == size })?.key {
            return key
        }

        return nil
    }
}
