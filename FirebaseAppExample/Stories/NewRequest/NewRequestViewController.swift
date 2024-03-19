//
//  NewRequestViewController.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

protocol NewRequestViewControllerActions: CollectionViewControllerActions {
    func setPrimaryButtonLoading(enabled: Bool)
}

final class NewRequestViewController: VerticalCollectionViewController {

    // MARK: - Outlets

    @IBOutlet private weak var discardButtonTouchableView: TouchableView!
    @IBOutlet private weak var collectionViewHolderView: UIView!

    @IBOutlet private weak var primaryButtonTouchableView: TouchableView!
    @IBOutlet private weak var primaryButtonView: LoadingView!
    @IBOutlet weak var primaryButtonBotConst: NSLayoutConstraint!
    
    // MARK: - Properties

    var viewModel: NewRequestViewModel!

    override var collectionViewTargetView: UIView {
        collectionViewHolderView
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupInteractions()
        setupCollectionView()

        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }

    // MARK: - Setup

    private func setupLayout() {
        view.themableBackgroundColor = .primaryBackground
        primaryButtonView.title = "Odoslať"
    }

    private func setupInteractions() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        
        discardButtonTouchableView.touchEngine.action = { [weak self] in
            self?.viewModel.discardButtonTapped()
        }
        primaryButtonTouchableView.touchEngine.action = { [weak self] in
            self?.viewModel.primaryButtonTapped()
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

    // MARK: - Actions



    // MARK: - Utilities

    @objc private func handleTap() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
      if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
          let keyboardHeight = keyboardFrame.height
          // Adjust content inset of the scroll view to accommodate keyboard
          collectionView.contentInset.bottom = keyboardHeight
          // Optionally, scroll to make the editing text view visible
          scrollToActiveTextView()
      }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        // Reset content inset of the scroll view to its initial value
        collectionView.contentInset.bottom = 0
    }
    
    func scrollToActiveTextView() {
      guard let collectionView = collectionView, let activeIndexPath = getActiveTextViewIndexPath() else { return }

      // Calculate the frame of the active text view in the collection view's coordinate space
      let activeTextViewFrame = collectionView.layoutAttributesForItem(at: activeIndexPath)?.frame ?? .zero

      // Calculate the content offset needed to make the active text view visible
      let contentOffset = collectionView.contentOffset
      let collectionVierwFrame = collectionView.frame
      var targetContentOffset = contentOffset

      // Check if the left edge of the active text view is outside the visible area
      if activeTextViewFrame.minX < contentOffset.x {
        targetContentOffset.x = activeTextViewFrame.minX
      }

      // Check if the right edge of the active text view is outside the visible area (considering collection view width)
      if activeTextViewFrame.maxX > (contentOffset.x + collectionVierwFrame.width) {
        targetContentOffset.x = activeTextViewFrame.maxX - collectionVierwFrame.width
      }

      // Animate the scrolling to the target content offset
      collectionView.setContentOffset(targetContentOffset, animated: true)
    }
    
    func getActiveTextViewIndexPath() -> IndexPath? {
        for cell in collectionView.visibleCells {
            if cell.isFirstResponder {
                return collectionView.indexPath(for: cell)
            }
        }
        
        return nil
    }
}

extension NewRequestViewController: NewRequestViewControllerActions {
    func setPrimaryButtonLoading(enabled: Bool) {
        view.isUserInteractionEnabled = !enabled
        primaryButtonView.setLoading(enabled: enabled)
    }
}
