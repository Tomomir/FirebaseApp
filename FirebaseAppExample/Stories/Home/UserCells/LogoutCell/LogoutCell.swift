//
//  LogoutCell.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

protocol LogoutCellActions: AnyObject {

}

final class LogoutCell: UICollectionViewCell {

    // MARK: - Outlets

    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Properties

    private var model: LogoutCellModel!

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

extension LogoutCell: CellConfigurable {
    func configure(with model: LogoutCellModel) {
        self.model = model
        model.cell = self

        titleLabel.text = model.title
    }
}

extension LogoutCell: LogoutCellActions {
    
}
