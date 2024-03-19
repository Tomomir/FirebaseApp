//
//  NewRequestViewModel.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

final class NewRequestViewModel {

    // MARK: - Properties

    private let coordinator: NewRequestCoordinator
    private weak var viewController: NewRequestViewControllerActions?
    private let inputData: NewRequestInputData

    // MARK: - CellModels

    private lazy var titleTextFieldCellModel = TextFieldCellModel()
    private lazy var descriptionTextFieldCellModel = TextFieldCellModel()
    private lazy var descriptionTextViewCellModel = TextViewCellModel()
    private lazy var contentTextViewCellModel = TextViewCellModel(height: 240)
    
    
    var cellModels: [CellModel] = []

    // MARK: - Init

    init(coordinator: NewRequestCoordinator, viewController: NewRequestViewControllerActions?, inputData: NewRequestInputData) {
        self.coordinator = coordinator
        self.viewController = viewController
        self.inputData = inputData
    }

    // MARK: - Lifecycle

    func viewDidLoad() {
        loadData()
    }

    // MARK: - Actions

    func discardButtonTapped() {
        coordinator.stop(outputData: nil, completionAction: nil)
    }

    func primaryButtonTapped() {
        viewController?.setPrimaryButtonLoading(enabled: true)
        
        if let title = titleTextFieldCellModel.text,
           let subtitle = descriptionTextFieldCellModel.text,
           let text = contentTextViewCellModel.text {
            
            firDataService.createArticle(title: title, subtitle: subtitle, content: text) { [weak self] error in
                self?.viewController?.setPrimaryButtonLoading(enabled: false)
                if error == nil {
                    self?.discardButtonTapped()
                } else {
                    self?.coordinator.showAlertOneButton(title: "Chyba", message: error?.localizedDescription, oneButtonTitle: "Rozumiem", oneButtonAction: nil)
                }
            }
        } else {
            self.viewController?.setPrimaryButtonLoading(enabled: false)
            coordinator.showAlertOneButton(title: "Pre pokračovanie vyplňte všetky položky", oneButtonTitle: "Rozumiem")
        }
    }

    // MARK: - Utilities

    private func loadData() {
        cellModels = [
            HeaderCellModel(title: "Titulok"),
            titleTextFieldCellModel,
            SpaceCellModel(height: 10),
            HeaderCellModel(title: "Popis"),
            descriptionTextFieldCellModel,
            SpaceCellModel(height: 10),
            HeaderCellModel(title: "Text"),
            contentTextViewCellModel
        ]
        viewController?.reloadCollectionView(with: cellModels)
    }
}

extension NewRequestViewModel: CellModelDataSourceDelegate {
    func didSelect(_ collectionView: UICollectionView, cellModel: CellModel, at indexPath: IndexPath) {

    }
}
