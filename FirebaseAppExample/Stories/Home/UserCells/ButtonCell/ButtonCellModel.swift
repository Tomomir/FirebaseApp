//
//  ButtonCellModel.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

protocol ButtonCellModelDelegate: AnyObject {

}

final class ButtonCellModel: CellModelSuperclass {

    // MARK: - Types

    typealias CellType = ButtonCell

    // MARK: - Public Properties

    weak var cell: ButtonCellActions?

    // MARK: - Private Properties

    let title: String
    let titleTextStyle: TextStyle
    let subtitle: String?
    let style: RoundingStyle
    let isForwardIconHidden: Bool
    let action: Action?

    let height: CGFloat

    // MARK: - Init

    init(title: String, titleTextStyle: TextStyle = .buttonCellTitleBlack, subtitle: String? = nil, style: RoundingStyle = .standard, isForwardIconHidden: Bool = false, action: Action? = nil) {
        self.title = title
        self.titleTextStyle = titleTextStyle
        self.subtitle = subtitle
        self.style = style
        self.isForwardIconHidden = isForwardIconHidden
        self.action = action

        self.height = isForwardIconHidden ? 55 : 65
    }

    // MARK: - Resources

    var isSubtitleHidden: Bool {
        subtitle == nil
    }
}

extension ButtonCellModel {
    var cellSize: CGSize? {
        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }

    func configure(_ cell: AnyObject) {
        if let cell = cell as? ButtonCell {
            cell.configure(with: self)
        } else {
            assertionFailure("You are trying to configure cell of type \(type(of: cell)) on cellModel of type \(type(of: self))")
        }
    }
}

//extension XYViewModel: ButtonCellModelDelegate {
//
//}
