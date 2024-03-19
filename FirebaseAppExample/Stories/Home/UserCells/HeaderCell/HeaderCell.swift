//
//  HeaderCell.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

protocol HeaderCellActions: AnyObject {

}

final class HeaderCell: UICollectionViewCell {

    // MARK: - Outlets

    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Properties

    private var model: HeaderCellModel!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }

    // MARK: - Setup

    private func setupLayout() {

    }
}

extension HeaderCell: CellConfigurable {
    func configure(with model: HeaderCellModel) {
        self.model = model
        model.cell = self

        titleLabel.text = model.title
    }
}

extension HeaderCell: HeaderCellActions {
    
}
