//
//  CellModel.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

/// Every CellModel should be of this type - so it conforms to protocols CellModel and CellDefinable.
/// CellModel doesn't use generics, so it can be easily used in CellModelDataSource. CellDefinable uses generics.
public typealias CellModelSuperclass = CellModel & CellDefinable

/// Protocol CellModel prescribes that every CellModel has to have these properties: cellHeight, highlighting, separatorIsHidden
/// and properties for registering cells and dequeuing cells: reuseIdentifier, nib.
///
/// This protocol also prescribes that every CellModel has to implement method configure(_ cell: AnyObject), that is used by UICollectionViewDataSource
/// in method collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) for configuring the cell by CellModel.
///
/// Implementation of properties reuseIdentifier and nib and method configure(_ cell: AnyObject) is meant to be provided by protocol CellDefinable.
public protocol CellModel {
//    var timerable: Timerable? { get }

    var cellSize: CGSize? { get }
    var highlighting: Bool { get }
    var isSeparatorHidden: Bool { get }

    var reuseIdentifier: String { get }
    var nib: UINib? { get }

    func configure(_ cell: AnyObject)
}

/// Default implementation of properties: cellHeight, highlighting, isSeparatorHidden.
extension CellModel {
    public var uniqueIdentifier: String? {
        return nil
    }

    public var cellSize: CGSize? {
        return nil
    }

    public var highlighting: Bool {
        return true
    }

    public var isSeparatorHidden: Bool {
        return false
    }
}

/// Protocol that should be implemented by CellModel.
/// CellType has to be given - it should be UICollectionViewCell that implements protocol CellConfigurable
/// which means it is implementing method configure(with model:).
public protocol CellDefinable {
    associatedtype CellType: CellConfigurable
}

extension CellDefinable {
    public var reuseIdentifier: String {
        return String(describing: CellType.self)
    }

    public var nib: UINib? {
        return UINib(nibName: String(describing: CellType.self), bundle: Bundle(for: CellType.self))
    }
}

extension CellDefinable where Self == CellType.CellModelType {
    public func configure(_ cell: AnyObject) {
        if let cell = cell as? CellType {
            cell.configure(with: self)
        } else {
            assertionFailure("You are trying to configure cell of type \(type(of: cell)) on cellModel of type \(type(of: self))")
        }
    }
}

/// This protocol provides function configure(with model: CellModelType), that should be implemented by UICollectionViewCell,
/// to configure itself by given CellModel.
public protocol CellConfigurable: AnyObject {
    associatedtype CellModelType

    func configure(with model: CellModelType)
}
