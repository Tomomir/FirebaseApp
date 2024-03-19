//
//  DetailViewModel.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

final class DetailViewModel {

    // MARK: - Properties

    private let coordinator: DetailCoordinator
    private weak var viewController: DetailViewControllerActions?
    private let inputData: DetailInputData
    
    var textContent: String {
        get {
            inputData.text
        }
    }

    // MARK: - CellModels

    var cellModels: [CellModel] = []

    // MARK: - Init

    init(coordinator: DetailCoordinator, viewController: DetailViewControllerActions?, inputData: DetailInputData) {
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

    // MARK: - Utilities

    private func loadData() {

    }
}
