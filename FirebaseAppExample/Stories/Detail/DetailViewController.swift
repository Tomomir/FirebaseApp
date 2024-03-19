//
//  DetailViewController.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

protocol DetailViewControllerActions: AnyObject {

}

final class DetailViewController: UIViewController {

    // MARK: - Constants



    // MARK: - Outlets

    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var detailTextView: UITextView!
    

    // MARK: - Elements



    // MARK: - Properties

    var viewModel: DetailViewModel!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupInteractions()

        viewModel.viewDidLoad()
    }

    // MARK: - Setup

    private func setupLayout() {
        self.detailTextView.text = viewModel.textContent
        
        let contentSize = detailTextView.sizeThatFits(CGSize(width: detailTextView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        let totalHeight = (contentSize.height < 100 ? 100 : contentSize.height) + 90
        cardViewHeightConst.constant = totalHeight
    }

    private func setupInteractions() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapView.addGestureRecognizer(tap)
    }

    // MARK: - Actions



    // MARK: - Utilities

    @objc private func handleTap() {
        viewModel.discardButtonTapped()
    }
}

extension DetailViewController: DetailViewControllerActions {

}
