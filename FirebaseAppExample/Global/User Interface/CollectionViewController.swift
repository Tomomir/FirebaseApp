//
//  CollectionViewController.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

public protocol CollectionViewControllerActions: AnyObject {
    var collectionView: UICollectionView! { get }

    func reloadCollectionView(with cellModels: [CellModel])
}

open class CollectionViewController: UIViewController {

    // MARK: - Elements

    public var collectionView: UICollectionView!

    // MARK: - Properties

    open var collectionViewTargetView: UIView {
        return view
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

extension CollectionViewController: CollectionViewControllerActions {
    public func reloadCollectionView(with cellModels: [CellModel]) {
        dataSource?.reload(with: cellModels)
    }
}
