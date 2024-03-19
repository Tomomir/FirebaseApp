//
//  HomeViewModel+UserCellModelDelegate.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

extension HomeViewModel: UserCellModelDelegate {
    func changePhotoButtonTapped() {
        coordinator.showImagePicker(delegate: self)
    }
}
