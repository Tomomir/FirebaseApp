//
//  SpaceCellModel.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

protocol SpaceCellModelDelegate: AnyObject {

}

final class SpaceCellModel: CellModelSuperclass {

    // MARK: - Types

    typealias CellType = SpaceCell

    // MARK: - Public Properties

    weak var cell: SpaceCellActions?

    // MARK: - Private Properties

    private let height: CGFloat

    // MARK: - Init

    init(height: CGFloat) {
        self.height = height
    }

    // MARK: - Actions: From ViewModel



    // MARK: - Actions: From Cell



    // MARK: - Resources


}

extension SpaceCellModel {
    var cellSize: CGSize? {
        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }

    func configure(_ cell: AnyObject) {
        if let cell = cell as? SpaceCell {
            cell.configure(with: self)
        } else {
            assertionFailure("You are trying to configure cell of type \(type(of: cell)) on cellModel of type \(type(of: self))")
        }
    }
}

//extension XYViewModel: SpaceCellModelDelegate {
//
//}
