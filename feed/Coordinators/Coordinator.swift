//
//  Coordinator.swift
//  feed
//
//  Created by Rance Tsai on 10/2/20.
//

import Foundation

protocol CoordinatorProtocol {
    func start()
    func finish()
}

class Coordinator: CoordinatorProtocol {
    private var childCoordinators = [Coordinator]()

    func start() {}
    func finish() {}

    private func add(child: Coordinator) {
        childCoordinators.append(child)
    }

    private func remove(child: Coordinator) {
        if let index = childCoordinators.firstIndex(of: child) {
            childCoordinators.remove(at: index)
        }
    }
}

extension Coordinator: Equatable {
    static func == (lhs: Coordinator, rhs: Coordinator) -> Bool {
        lhs === rhs
    }
}
