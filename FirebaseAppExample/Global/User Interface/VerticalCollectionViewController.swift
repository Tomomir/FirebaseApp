//
//  VerticalCollectionViewController.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

open class VerticalCollectionViewController: UIViewController {

    // MARK: - Elements

    public var collectionView: UICollectionView!

    // MARK: - Properties

    open var collectionViewTargetView: UIView {
        return view
    }

    /// Default is `false` because we want to calculate size of cells manually. If default value should change other changes has to be made in corresponding controllers
    public var isAutosizingEnabled: Bool {
        return false
    }

    public var dataSource: CellModelDataSource? {
        didSet {
            collectionView.dataSource = dataSource
            collectionView.delegate = dataSource
        }
    }

    // MARK: - Lifecycle

    override open func viewDidLoad() {
        super.viewDidLoad()
        createCollectionView()
    }

    // MARK: - Creation

    func createCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        if isAutosizingEnabled {
            layout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
        collectionView = UICollectionView(frame: collectionViewTargetView.frame, collectionViewLayout: layout)

        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = true
        collectionView.alwaysBounceVertical = false
        collectionView.indicatorStyle = .default
        collectionView.keyboardDismissMode = .interactive
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false

        collectionViewTargetView.addSubviewWithConstraintsToEdges(collectionView)
    }
}

extension VerticalCollectionViewController: CollectionViewControllerActions {
    public func reloadCollectionView(with cellModels: [CellModel]) {
        dataSource?.reload(with: cellModels)
    }
}
