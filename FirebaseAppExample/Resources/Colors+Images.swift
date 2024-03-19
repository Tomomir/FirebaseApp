//
//  Colors+Images.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

enum ColorKey: String {
    case clear

    case alwaysWhite
    case alwaysBlack
    case alwaysRed

    case primaryBackground

    case primaryButton

    case notSelected
    case selected
}

enum ImageKey: String {
    case empty
}

final class LightTheme: Theme {
    func color(for colorKey: ColorKey) -> UIColor {
        switch colorKey {
        case .clear:
            return .clear

        case .alwaysWhite:
            return .white
        case .alwaysBlack:
            return .black
        case .alwaysRed:
            return #colorLiteral(red: 0.5933554293, green: 0.06854172589, blue: 0.09307175331, alpha: 1)

        case .primaryBackground:
            return #colorLiteral(red: 0.9685427547, green: 0.9686817527, blue: 0.9685125947, alpha: 1)

        case .primaryButton:
            return #colorLiteral(red: 0.2052493095, green: 0.4721993804, blue: 0.9654459357, alpha: 1)

        case .notSelected:
            return #colorLiteral(red: 0.7133443813, green: 0.7133443813, blue: 0.7133443813, alpha: 1)
        case .selected:
            return #colorLiteral(red: 0.9780682921, green: 0.3430373073, blue: 0, alpha: 1)
        }
    }

    func image(for imageKey: ImageKey) -> UIImage {
        switch imageKey {
        case .empty:
            return UIImage()
        }
    }
}
