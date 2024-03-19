//
//  HeaderCellModel.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

protocol HeaderCellModelDelegate: AnyObject {

}

final class HeaderCellModel: CellModelSuperclass {

    // MARK: - Constants

    static let height: CGFloat = 30

    // MARK: - Types

    typealias CellType = HeaderCell

    // MARK: - Public Properties

    weak var cell: HeaderCellActions?

    // MARK: - Private Properties

    let title: String

    // MARK: - Init

    init(title: String) {
        self.title = title
    }
}

extension HeaderCellModel {
    var cellSize: CGSize? {
        return CGSize(width: UIScreen.main.bounds.width, height: HeaderCellModel.height)
    }

    func configure(_ cell: AnyObject) {
        if let cell = cell as? HeaderCell {
            cell.configure(with: self)
        } else {
            assertionFailure("You are trying to configure cell of type \(type(of: cell)) on cellModel of type \(type(of: self))")
        }
    }
}

//extension XYViewModel: HeaderCellModelDelegate {
//
//}
