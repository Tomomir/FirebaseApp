//
//  LogoutCellModel.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

protocol LogoutCellModelDelegate: AnyObject {

}

final class LogoutCellModel: CellModelSuperclass {

    // MARK: - Constants

    static let height: CGFloat = 65

    // MARK: - Types

    typealias CellType = LogoutCell

    // MARK: - Public Properties

    weak var cell: LogoutCellActions?

    // MARK: - Private Properties

    let title: String
    let action: Action

    // MARK: - Init

    init(title: String, action: @escaping Action) {
        self.title = title
        self.action = action
    }

    // MARK: - Actions: From ViewModel



    // MARK: - Actions: From Cell



    // MARK: - Resources


}

extension LogoutCellModel {
    var cellSize: CGSize? {
        return CGSize(width: UIScreen.main.bounds.width, height: LogoutCellModel.height)
    }

    func configure(_ cell: AnyObject) {
        if let cell = cell as? LogoutCell {
            cell.configure(with: self)
        } else {
            assertionFailure("You are trying to configure cell of type \(type(of: cell)) on cellModel of type \(type(of: self))")
        }
    }
}

//extension XYViewModel: LogoutCellModelDelegate {
//
//}
