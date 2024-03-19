//
//  TextViewCellModel.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

protocol TextViewCellModelDelegate: AnyObject {

}

final class TextViewCellModel: CellModelSuperclass {

    // MARK: - Constants

    let height: CGFloat

    // MARK: - Types

    typealias CellType = TextViewCell

    // MARK: - Public Properties

    weak var cell: TextViewCellActions?
    var text: String?

    // MARK: - Private Properties

    private weak var delegate: TextViewCellModelDelegate?

    // MARK: - Init

    init(delegate: TextViewCellModelDelegate? = nil, height: CGFloat = 100) {
        self.delegate = delegate
        self.height = height
    }

    // MARK: - Actions: From ViewModel



    // MARK: - Actions: From Cell

    func textDidChange(to text: String?) {
        self.text = text
    }

    // MARK: - Resources


}

extension TextViewCellModel {
    var cellSize: CGSize? {
        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }

    func configure(_ cell: AnyObject) {
        if let cell = cell as? TextViewCell {
            cell.configure(with: self)
        } else {
            assertionFailure("You are trying to configure cell of type \(type(of: cell)) on cellModel of type \(type(of: self))")
        }
    }
}
