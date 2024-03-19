//
//  RequestCellModel.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

final class RequestCellModel: CellModelSuperclass {

    // MARK: - Types

    typealias CellType = RequestCell

    // MARK: - Properties

    weak var cell: RequestCellActions?
    var article: Article?
    
    // MARK: - Init

    init(article: Article) {
        self.article = article
    }
    
    // MARK: - Actions: From ViewModel


    // MARK: - Actions: From Cell


    // MARK: - Resources


}

extension RequestCellModel {
    var cellSize: CGSize? {
        return CGSize(width: UIScreen.main.bounds.width, height: 197.5 + 15)
    }

    func configure(_ cell: AnyObject) {
        if let cell = cell as? RequestCell {
            cell.configure(with: self)
        } else {
            assertionFailure("You are trying to configure cell of type \(type(of: cell)) on cellModel of type \(type(of: self))")
        }
    }
}
