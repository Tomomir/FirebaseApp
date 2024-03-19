//
//  TextStyles.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

struct LineSpacing {
    static let tight: CGFloat = 1
    static let medium: CGFloat = 2
    static let standard: CGFloat = 3
}

extension UIFont {
    static let textInput = UIFont.systemFont(ofSize: 16, weight: .regular)
    static let buttonTitle = UIFont.systemFont(ofSize: 13, weight: .bold)
    static let buttonCellTitle = UIFont.systemFont(ofSize: 16, weight: .bold)
}

extension TextStyle {
    static let textInput = TextStyle(font: .textInput, colorKey: .alwaysBlack, alignment: .left)
    static let textInputPlaceholder = TextStyle(font: .textInput, colorKey: .notSelected, alignment: .left)
    static let buttonTitleWhite = TextStyle(font: .buttonTitle, colorKey: .alwaysWhite, alignment: .center)

    static let buttonCellTitleBlack = TextStyle(font: .buttonCellTitle, colorKey: .alwaysBlack, alignment: .left)
    static let buttonCellTitleRed = TextStyle(font: .buttonCellTitle, colorKey: .alwaysRed, alignment: .left)
}
