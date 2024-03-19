//
//  CellModelDataSource.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

public protocol CellModelDataSourceScrollViewDelegate: AnyObject {
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
}

extension CellModelDataSourceScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
}

public protocol CellModelDataSourceDelegate: AnyObject {
    func didSelect(_ collectionView: UICollectionView, cellModel: CellModel, at indexPath: IndexPath)
    func willBeginDragging(_ scrollView: UIScrollView)
    func willEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    func didEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    func didEndDecelerating(_ scrollView: UIScrollView)
    func didEndScrollingAnimation(_ scrollView: UIScrollView)
    func didScroll(_ scrollView: UIScrollView)
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath])
}

extension CellModelDataSourceDelegate {
    public func didSelect(_ collectionView: UICollectionView, cellModel: CellModel, at indexPath: IndexPath) { }
    public func willBeginDragging(_ scrollView: UIScrollView) { }
    public func willEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) { }
    public func didEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) { }
    public func didEndDecelerating(_ scrollView: UIScrollView) { }
    public func didEndScrollingAnimation(_ scrollView: UIScrollView) { }
    public func didScroll(_ scrollView: UIScrollView) { }
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) { }
}

protocol CellModelDataSourceDragDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
}

extension CellModelDataSourceDragDelegate {
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool { return false }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) { }
}

protocol CellModelDataSourceDataDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

public protocol CellModelViewPortTimerDelegate: AnyObject {
    func updateLabel(text: String)
}

enum ScrollDirection {
    case up, down
}

public class CellModelDataSource: NSObject {

    // MARK: - Types

    public class Section {
        let index = 0

        var cellModels: [CellModel] = [CellModel]()

        init(cellModels: [CellModel]) {
            self.cellModels = cellModels
        }
    }

    // MARK: - Properties

    public weak var delegate: CellModelDataSourceDelegate?
    weak var dragDelegate: CellModelDataSourceDragDelegate?
    weak var dataDelegate: CellModelDataSourceDataDelegate?
    weak var scrollViewDelegate: CellModelDataSourceScrollViewDelegate?

    public weak var collectionView: UICollectionView?
    public var sections: [Section]

    public var isCollectionViewScrolling: Bool = false

    private var lastContentOffset: CGFloat = 0
    var lastScrollDirection: ScrollDirection = .down

    // MARK: - Init

    public init(_ collectionView: UICollectionView, sections: [Section]) {
        self.collectionView = collectionView
        self.sections = sections
        super.init()
        registerCells(for: collectionView)
    }

    public convenience init(_ collectionView: UICollectionView, cellModels: [CellModel]) {
        self.init(collectionView, sections: [Section(cellModels: cellModels)])
    }

    // MARK: - Helpers

    public func registerCells(for collectionView: UICollectionView?) {
        sections.forEach { section in
             // TODO: Everytime all cells are registered -> Fix needed.
            section.cellModels.forEach { collectionView?.register($0.nib, forCellWithReuseIdentifier: $0.reuseIdentifier) }
        }
    }

    func cellModel(at indexPath: IndexPath) -> CellModel {
        return sections[indexPath.section].cellModels[indexPath.row]
    }

    // MARK: - Utilities

    func reload(with sections: [Section]) {
        self.sections = sections
        registerCells(for: collectionView)
        collectionView?.reloadData()
    }

    func reload(with cellModels: [CellModel]) {
        reload(with: [Section(cellModels: cellModels)])
    }

    func update(with cellModels: [CellModel]) {
        self.sections = [Section(cellModels: cellModels)]
        registerCells(for: collectionView)
    }

    func insertAtTheEnd(newCellModels: [CellModel]) {
        self.sections.first?.cellModels += newCellModels
        registerCells(for: collectionView)
    }

    func insert(newCellModels: [CellModel], index: Int) {
        guard let firstSection = sections.first else {
            return
        }
        newCellModels.reversed().forEach {
            firstSection.cellModels.insert($0, at: index)
        }
        registerCells(for: collectionView)
    }

    func replaceCellModels(firstIndex: Int, lastIndex: Int, newCellModels: [CellModel]) {
        sections.first?.cellModels.removeSubrange(firstIndex...lastIndex)
        sections.first?.cellModels.insert(contentsOf: newCellModels, at: firstIndex)
        registerCells(for: collectionView)
    }

    func removeCellModels(firstCellModelIndex: Int, numberOfCellModels: Int) {
        for _ in 1...numberOfCellModels {
            self.sections.first?.cellModels.remove(at: firstCellModelIndex)
        }
    }
}

extension CellModelDataSource: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].cellModels.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dataDelegate = dataDelegate else {
            let cellModel = self.cellModel(at: indexPath)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellModel.reuseIdentifier, for: indexPath)
            cellModel.configure(cell)
            return cell
        }
        return dataDelegate.collectionView(collectionView, cellForItemAt: indexPath)
    }
}

extension CellModelDataSource: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cellSize = sections[indexPath.section].cellModels[indexPath.row].cellSize else {
            return CGSize(width: 1, height: 1)
        }
        return cellSize
    }
}

extension CellModelDataSource: UICollectionViewDataSourcePrefetching {
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        delegate?.collectionView(collectionView, prefetchItemsAt: indexPaths)
    }
}

extension CellModelDataSource: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellModel = self.cellModel(at: indexPath)
        delegate?.didSelect(collectionView, cellModel: cellModel, at: indexPath)
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.willBeginDragging(scrollView)
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.willEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.didEndDragging(scrollView, willDecelerate: decelerate)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.didEndDecelerating(scrollView)
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isCollectionViewScrolling = false
        delegate?.didEndScrollingAnimation(scrollView)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if lastContentOffset > scrollView.contentOffset.y && lastContentOffset < scrollView.contentSize.height - scrollView.frame.height {
            lastScrollDirection = .up
        } else if lastContentOffset < scrollView.contentOffset.y && scrollView.contentOffset.y > 0 {
            lastScrollDirection = .down
        }
        // update the new position acquired
        lastContentOffset = scrollView.contentOffset.y

        isCollectionViewScrolling = true
        delegate?.didScroll(scrollView)

        // scrollViewDidEndScrollingAnimation is called only for setContentOffset(_:animated:) and scrollRectToVisible(_:animated:) methods
        // with this code it is called really every time scrolling stops.
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(UIScrollViewDelegate.scrollViewDidEndScrollingAnimation), with: nil, afterDelay: 0.15)

//        if let collectionView = collectionView {
//            viewPortManager.updateAllViewPortTimers(in: collectionView)
//        }
    }

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollViewDelegate?.viewForZooming(in: scrollView)
    }

    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return dragDelegate?.collectionView(collectionView, canMoveItemAt: indexPath) ?? false
    }

    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dragDelegate?.collectionView(collectionView, moveItemAt: sourceIndexPath, to: destinationIndexPath)
    }
}
