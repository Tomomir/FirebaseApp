//
//  Themes.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

enum ThemeKey: String {

    case light
    case dark

    var value: Theme {
        switch self {
        case .light:
            return LightTheme()
        case .dark:
            return LightTheme()
        }
    }
}
