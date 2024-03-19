//
//  UserCellModel.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

protocol UserCellModelDelegate: AnyObject {
    func changePhotoButtonTapped()
}

final class UserCellModel: CellModelSuperclass {

    // MARK: - Constants

    static let height: CGFloat = 200

    // MARK: - Types

    typealias CellType = UserCell

    // MARK: - Public Properties

    weak var cell: UserCell?

    var profileImage: UIImage? = UIImage(named: "profilePlaceholder")
    var isLoading: Bool = false

    // MARK: - Private Properties

    private weak var delegate: UserCellModelDelegate?

    // MARK: - Init

    init(delegate: UserCellModelDelegate?) {
        self.delegate = delegate
    }

    // MARK: - Actions: From ViewModel

    func fetchProfileImage() {
        Logger.log(string: "fetch profile picture called", type: .all)
        if let userId = firUserService.currentUser?.uid {
            firDataService.getUser(userId: userId) { [weak self] error, user in
                if let imageUrlString = user?.profileImageUrl {
                    if imageUrlString == "" { return }
                    firDataService.loadImageFromFirebaseStorage(with: imageUrlString) { [weak self] image, error in
                        self?.updateCellImageFinished(image: image, success: error == nil)
                    }
                }
            }
        }
    }
    
    func setPlaceHolederProfileImage() {
        let placeholderImage = UIImage(named: "profilePlaceholder")
        profileImage = placeholderImage
        self.cell?.updateImage()
    }
    
    func updateCellImageFinished(image: UIImage?, success: Bool) {
        self.setIsLoading(isLoading: false)
        if success {
            self.profileImage = image
            self.cell?.updateImage()
        }
    }
    
    func deleteCellImageFinished(success: Bool) {
        self.setIsLoading(isLoading: false)
        if success {
            self.profileImage = UIImage(named: "profilePlaceholder")
            cell?.updateImage()
            cell?.updateLoading()
        }
    }
    
    func setIsLoading(isLoading: Bool) {
        self.isLoading = isLoading
        cell?.updateLoading()
    }
    
    func updateUserEmailLabel() {
        cell?.updateEmail()
    }

    // MARK: - Actions: From Cell

    func changePhotoButtonTapped() {
        delegate?.changePhotoButtonTapped()
    }

    // MARK: - Resources


}

extension UserCellModel {
    var cellSize: CGSize? {
        return CGSize(width: UIScreen.main.bounds.width, height: UserCellModel.height)
    }

    func configure(_ cell: AnyObject) {
        if let cell = cell as? UserCell {
            cell.configure(with: self)
        } else {
            assertionFailure("You are trying to configure cell of type \(type(of: cell)) on cellModel of type \(type(of: self))")
        }
    }
}

//extension XYViewModel: UserCellModelDelegate {
//
//}
