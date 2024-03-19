//
//  SpaceCell.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

protocol SpaceCellActions: AnyObject {

}

final class SpaceCell: UICollectionViewCell {

    // MARK: - Outlets



    // MARK: - Properties

    private var model: SpaceCellModel!

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

extension SpaceCell: CellConfigurable {
    func configure(with model: SpaceCellModel) {
        self.model = model
        model.cell = self


    }
}

extension SpaceCell: SpaceCellActions {
    
}
