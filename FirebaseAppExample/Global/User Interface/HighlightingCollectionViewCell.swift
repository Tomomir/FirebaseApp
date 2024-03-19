//
//  HighlightingCollectionViewCell.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

class HighlightingCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    var highlightScale: CGFloat {
        return 0.98
    }

    // MARK: - Lifecycle

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                    self.contentView.transform = CGAffineTransform(scaleX: self.highlightScale, y: self.highlightScale)
                })
            } else {
                UIView.animate(withDuration: 0.15, delay: 0.05, options: .curveEaseOut, animations: {
                    self.contentView.transform = .identity
                })
            }
        }
    }
}
