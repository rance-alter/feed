//
//  AppCoordinator.swift
//  feed
//
//  Created by Rance Tsai on 10/2/20.
//

import UIKit

final class AppCoordinator: Coordinator {
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    override func start() {
        window.makeKeyAndVisible()
        window.rootViewController = MainViewController()
    }
}
