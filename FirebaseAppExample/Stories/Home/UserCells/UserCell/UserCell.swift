//
//  UserCell.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

final class UserCell: UICollectionViewCell {

    // MARK: - Outlets

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var cameraIconImageView: UIImageView!
    @IBOutlet private weak var changePhotoButtonTouchableView: TouchableView!

    // MARK: - Properties

    private var model: UserCellModel!

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
        changePhotoButtonTouchableView.touchEngine.action = { [weak self] in
            self?.model.changePhotoButtonTapped()
        }
    }

    // MARK: - Actions

    func updateImage() {
        self.profileImageView.image = model.profileImage
    }
    
    func updateEmail() {
        emailLabel.text = firUserService.userEmail
    }
    
    func updateLoading() {
        if model.isLoading {
            self.cameraIconImageView.isHidden = true
            self.activityIndicatorView.startAnimating()
        } else {
            self.cameraIconImageView.isHidden = false
            self.activityIndicatorView.stopAnimating()
        }
    }

    // MARK: - Utilities


}

extension UserCell: CellConfigurable {
    func configure(with model: UserCellModel) {
        self.model = model
        model.cell = self

        emailLabel.text = firUserService.userEmail
        model.fetchProfileImage()
    }
}
