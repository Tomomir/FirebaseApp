//
//  TextFieldCell.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

protocol TextFieldCellActions: AnyObject {

}

final class TextFieldCell: UICollectionViewCell {

    // MARK: - Outlets

    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var textFieldClearButtonTouchableView: TouchableView!

    // MARK: - Properties

    private var model: TextFieldCellModel!

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
        textField.delegate = self
    }

    // MARK: - Actions

    @IBAction private func textFieldEditingChanged(_ sender: Any) {
        model.textDidChange(to: textField.text)
    }

    @IBAction private func textFieldPrimaryActionTriggered(_ sender: Any) {

    }

    // MARK: - Utilities


}

extension TextFieldCell: CellConfigurable {
    func configure(with model: TextFieldCellModel) {
        self.model = model
        model.cell = self


    }
}

extension TextFieldCell: TextFieldCellActions {
    
}

extension TextFieldCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
