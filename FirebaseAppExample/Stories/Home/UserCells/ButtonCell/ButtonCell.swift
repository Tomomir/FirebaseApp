//
//  ButtonCell.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

protocol ButtonCellActions: AnyObject {

}

final class ButtonCell: HighlightingCollectionViewCell {

    // MARK: - Outlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    @IBOutlet private weak var topBackgroundView: UIView!
    @IBOutlet private weak var centerBackgroundView: UIView!
    @IBOutlet private weak var bottomBackgroundView: UIView!

    @IBOutlet private weak var forwardIconImageView: UIImageView!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var separatorViewHeightConstraint: NSLayoutConstraint!

    // MARK: - Properties

    private var model: ButtonCellModel!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
        setupInteractions()
    }

    // MARK: - Setup

    private func setupLayout() {
        [topBackgroundView, centerBackgroundView, bottomBackgroundView].forEach {
            $0?.themableBackgroundColor = .alwaysWhite
        }
        separatorViewHeightConstraint.constant = 0.5
    }

    private func setupInteractions() {

    }

    // MARK: - Utilities

    private func set(style: RoundingStyle) {
        [topBackgroundView, centerBackgroundView, bottomBackgroundView].forEach {
            $0?.setup(cornerRadius: 0)
        }
        separatorView.isHidden = true
        switch style {
        case .roundedTop:
            topBackgroundView.setup(cornerRadius: 10)
            separatorView.isHidden = false
        case .standard:
            separatorView.isHidden = false
        case .roundedBottom:
            bottomBackgroundView.setup(cornerRadius: 10)
        case .roundedTopAndBottom:
            topBackgroundView.setup(cornerRadius: 10)
            bottomBackgroundView.setup(cornerRadius: 10)
        }
    }
}

extension ButtonCell: CellConfigurable {
    func configure(with model: ButtonCellModel) {
        self.model = model
        model.cell = self

        titleLabel.setup(textStyle: model.titleTextStyle, newText: model.title)
        subtitleLabel.text = model.subtitle
        subtitleLabel.isHidden = model.isSubtitleHidden

        set(style: model.style)
        forwardIconImageView.isHidden = model.isForwardIconHidden
    }
}

extension ButtonCell: ButtonCellActions {
    
}
