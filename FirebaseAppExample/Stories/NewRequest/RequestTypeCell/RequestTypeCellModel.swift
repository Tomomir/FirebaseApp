//
//  RequestTypeCellModel.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

protocol RequestTypeCellModelDelegate: AnyObject {

}

final class RequestTypeCellModel: CellModelSuperclass {

    // MARK: - Constants

    static let height: CGFloat = 50

    // MARK: - Types

    typealias CellType = RequestTypeCell

    // MARK: - Public Properties

    weak var cell: RequestTypeCellActions?

    // MARK: - Private Properties

    private weak var delegate: RequestTypeCellModelDelegate?

    // MARK: - Init

    init(delegate: RequestTypeCellModelDelegate? = nil) {
        self.delegate = delegate
    }

    // MARK: - Actions: From ViewModel



    // MARK: - Actions: From Cell



    // MARK: - Resources


}

extension RequestTypeCellModel {
    var cellSize: CGSize? {
        return CGSize(width: UIScreen.main.bounds.width, height: RequestTypeCellModel.height)
    }

    func configure(_ cell: AnyObject) {
        if let cell = cell as? RequestTypeCell {
            cell.configure(with: self)
        } else {
            assertionFailure("You are trying to configure cell of type \(type(of: cell)) on cellModel of type \(type(of: self))")
        }
    }
}
