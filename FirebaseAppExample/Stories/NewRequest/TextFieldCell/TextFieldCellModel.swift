//
//  TextFieldCellModel.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

protocol TextFieldCellModelDelegate: AnyObject {

}

final class TextFieldCellModel: CellModelSuperclass {

    // MARK: - Constants

    static let height: CGFloat = 48

    // MARK: - Types

    typealias CellType = TextFieldCell

    // MARK: - Public Properties

    weak var cell: TextFieldCellActions?
    var text: String?
    
    // MARK: - Private Properties

    private weak var delegate: TextFieldCellModelDelegate?

    // MARK: - Init

    init(delegate: TextFieldCellModelDelegate? = nil) {
        self.delegate = delegate
    }

    // MARK: - Actions: From ViewModel



    // MARK: - Actions: From Cell

    func textDidChange(to text: String?) {
        self.text = text
    }

    // MARK: - Resources


}

extension TextFieldCellModel {
    var cellSize: CGSize? {
        return CGSize(width: UIScreen.main.bounds.width, height: TextFieldCellModel.height)
    }

    func configure(_ cell: AnyObject) {
        if let cell = cell as? TextFieldCell {
            cell.configure(with: self)
        } else {
            assertionFailure("You are trying to configure cell of type \(type(of: cell)) on cellModel of type \(type(of: self))")
        }
    }
}
