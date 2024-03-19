//
//  RequestTypeCell.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

protocol RequestTypeCellActions: AnyObject {

}

final class RequestTypeCell: UICollectionViewCell {

    // MARK: - Outlets



    // MARK: - Properties

    private var model: RequestTypeCellModel!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
        setupInteractions()
    }

    // MARK: - Setup

    private func setupLayout() {

    }

    private func setupInteractions() {

    }

    // MARK: - Actions



    // MARK: - Utilities


}

extension RequestTypeCell: CellConfigurable {
    func configure(with model: RequestTypeCellModel) {
        self.model = model
        model.cell = self
    }
}

extension RequestTypeCell: RequestTypeCellActions {
    
}
