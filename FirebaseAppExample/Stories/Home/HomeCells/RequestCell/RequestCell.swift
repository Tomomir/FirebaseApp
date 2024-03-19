//
//  RequestCell.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

protocol RequestCellActions: AnyObject {
    func setProfileImage(image: UIImage?)
    func setCreatorName(name: String)
}

final class RequestCell: HighlightingCollectionViewCell {

    // MARK: - Outlets

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var creatorNameLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Properties

    private var model: RequestCellModel!

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

extension RequestCell: CellConfigurable {
    func configure(with model: RequestCellModel) {
        self.model = model
        model.cell = self

        titleLabel.text = model.article?.title
        descriptionLabel.text = model.article?.subtitle
        creatorNameLabel.text = model.article?.creatorName
        dateLabel.text = model.article?.parsedDate
    }
}

extension RequestCell: RequestCellActions {
    func setCreatorName(name: String) {
        self.creatorNameLabel.text = name
    }
    
    func setProfileImage(image: UIImage?) {
        self.profileImageView.image = image
    }
}
