//
//  LoadingView.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

class LoadingView: UIView {

    // MARK: - Elemetns

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        return titleLabel
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        return imageView
    }()

    // MARK: - Properties

    var isRotating: Bool = false

    var loadingImageSize: CGFloat = 25
    var loadingImage: UIImage? = UIImage(named: "icLoading3") {
        didSet {
            imageView.image = loadingImage
            updateImageView()
        }
    }
    var loadingImageTintColor: UIColor = .white {
        didSet {
            updateImageView()
        }
    }

    var title: String = "" {
        didSet {
            updateTitleLabel()
        }
    }
    var titleTextStyle: TextStyle = .buttonTitleWhite {
        didSet {
            updateTitleLabel()
        }
    }

    // MARK: - Init

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    private func initialize() {
        setupLayout()
    }

    // MARK: - Setup

    private func setupLayout() {
        addSubviewWithConstraintsToCenter(imageView)
        imageView.addConstraints(height: loadingImageSize, width: loadingImageSize)
        updateImageView()

        addSubviewWithConstraintsToEdges(titleLabel)
        updateTitleLabel()
    }

    // MARK: - Actions

    func setLoading(enabled: Bool) {
        titleLabel.isHidden = enabled
        enabled ? startRotating() : stopRotating()
        imageView.isHidden = !enabled
    }

    // MARK: - Utilities

    private func updateImageView() {
        imageView.image = loadingImage
        imageView.tintColor = loadingImageTintColor
    }

    private func updateTitleLabel() {
        titleLabel.setup(textStyle: titleTextStyle, newText: title)
    }

    private func startRotating() {
        guard !isRotating else {
            return
        }
        isRotating = true
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        imageView.layer.add(rotation, forKey: "rotationAnimation")
    }

    private func stopRotating() {
        imageView.layer.removeAnimation(forKey: "rotationAnimation")
        isRotating = false
    }
}
