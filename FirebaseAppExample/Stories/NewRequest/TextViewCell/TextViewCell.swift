//
//  TextViewCell.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

protocol TextViewCellActions: AnyObject {

}

final class TextViewCell: UICollectionViewCell {

    // MARK: - Outlets

    @IBOutlet weak var textView: UITextView!

    // MARK: - Properties

    private var model: TextViewCellModel!

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
        textView.delegate = self
    }

    // MARK: - Actions



    // MARK: - Utilities


}

extension TextViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        model.textDidChange(to: textView.text)
    }
}

extension TextViewCell: CellConfigurable {
    func configure(with model: TextViewCellModel) {
        self.model = model
        model.cell = self


    }
}

extension TextViewCell: TextViewCellActions {
    
}
