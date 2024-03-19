//
//  Coordinator+Utilities.swift
//
//  Created by Tomas Pecuch on 18/03/2024.
//

import UIKit

public protocol StoryboardType {
    static var name: String { get }
}

public struct StoryboardReference<S: StoryboardType, T> {

    // MARK: - Properties

    private let id: String

    // MARK: - Init

    public init(id: String) {
        self.id = id
    }

    // MARK: - Actions

    public func instantiate() -> T {
        if let controller = UIStoryboard(name: S.name, bundle: nil).instantiateViewController(withIdentifier: id) as? T {
            return controller
        } else {
            fatalError("Instantiated controller with \(id) has different type than expected!")
        }
    }
}
