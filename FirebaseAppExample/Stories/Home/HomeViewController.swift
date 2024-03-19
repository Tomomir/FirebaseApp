//
//  HomeViewController.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

protocol HomeViewControllerActions: CollectionViewControllerActions {
    var userCollectionView: UICollectionView! { get }

    func updateScreenState()
}

final class HomeViewController: CollectionViewController {

    // MARK: - Outlets

    @IBOutlet private weak var collectionViewHolderView: UIView!
    @IBOutlet private weak var separatorViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var plusTouchableView: TouchableView!

    @IBOutlet private weak var userScreenHolderView: UIView!
    @IBOutlet private weak var loginNeededHolderView: UIView!
    @IBOutlet private weak var userHolderView: UIView!

    @IBOutlet private weak var homeTouchableView: TouchableView!
    @IBOutlet private weak var homeImageView: UIImageView!
    @IBOutlet private weak var userTouchableView: TouchableView!
    @IBOutlet private weak var userImageView: UIImageView!

    @IBOutlet private weak var loginButtonTouchableView: TouchableView!
    @IBOutlet private weak var signupButtonTouchableView: TouchableView!

    // MARK: - Elements

    var userCollectionView: UICollectionView!

    // MARK: - Properties

    var viewModel: HomeViewModel!

    override var collectionViewTargetView: UIView {
        collectionViewHolderView
    }

    public var userDataSource: CellModelDataSource? {
        didSet {
            userCollectionView.dataSource = userDataSource
            userCollectionView.delegate = userDataSource
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        createContentCollectionView()

        setupLayout()
        setupInteractions()
        setupCollectionView()
        setupUserCollectionView()

        updateScreenState()
        viewModel.viewDidLoad()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }

    // MARK: - Creation

    func createContentCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        userCollectionView = UICollectionView(frame: userHolderView.frame, collectionViewLayout: layout)

        userCollectionView.contentInsetAdjustmentBehavior = .never
        userCollectionView.backgroundColor = .clear
        userCollectionView.clipsToBounds = true
        userCollectionView.alwaysBounceVertical = true
        userCollectionView.bounces = true
        userCollectionView.showsVerticalScrollIndicator = false
        userCollectionView.showsHorizontalScrollIndicator = false
        userCollectionView.delaysContentTouches = false
        
        let safeAreaTop = view.window?.safeAreaInsets.top ?? 0        
        userCollectionView.contentInset = UIEdgeInsets(top: safeAreaTop + 50, left: 0, bottom: 50, right: 0)

        userHolderView.addSubviewWithConstraintsToEdges(userCollectionView)
    }

    // MARK: - Setup

    private func setupLayout() {
        separatorViewHeightConstraint.constant = 0.5

        userScreenHolderView.themableBackgroundColor = .primaryBackground
        loginNeededHolderView.backgroundColor = .clear
        userHolderView.backgroundColor = .clear
    }

    private func setupInteractions() {
        plusTouchableView.touchEngine.action = { [weak self] in
            self?.viewModel.plusButtonTapped()
        }
        homeTouchableView.touchEngine.action = { [weak self] in
            self?.viewModel.homeButtonTapped()
        }
        userTouchableView.touchEngine.action = { [weak self] in
            self?.viewModel.userButtonTapped()
        }
        loginButtonTouchableView.touchEngine.action = { [weak self] in
            self?.viewModel.loginButtonTapped()
        }
        signupButtonTouchableView.touchEngine.action = { [weak self] in
            self?.viewModel.signupButtonTapped()
        }
    }

    private func setupCollectionView() {
        dataSource = CellModelDataSource(collectionView, cellModels: viewModel.cellModels)
        dataSource?.delegate = viewModel

        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: (view.window?.safeAreaInsets.bottom ?? 0) + 60 + 30, right: 0)
        collectionView.clipsToBounds = true
        collectionView.alwaysBounceVertical = true
        collectionView.alwaysBounceHorizontal = false
        collectionView.delaysContentTouches = false
        collectionView.bounces = true
    }

    internal func setupUserCollectionView() {
        userDataSource = CellModelDataSource(userCollectionView, cellModels: viewModel.userCellModels)
        userDataSource?.delegate = viewModel
    }
}

extension HomeViewController: HomeViewControllerActions {
    func updateScreenState() {
        let isHome = viewModel.screenState == .home
        userScreenHolderView.isHidden = isHome
        homeImageView.themableTintColor = isHome ? .selected : .notSelected
        userImageView.themableTintColor = isHome ? .notSelected : .selected

        let isUserLoggedIn = viewModel.userScreenState == .userLoggedIn
        loginNeededHolderView.isHidden = isUserLoggedIn
        userHolderView.isHidden = !isUserLoggedIn
    }
}
