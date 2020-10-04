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
        let mainVC = MainViewController()
        mainVC.delegate = self
        window.rootViewController = mainVC
    }
}

extension AppCoordinator: MainViewControllerDelegate {

    func onLoadPageFailure(from viewController: UIViewController) {
        let alertVC = UIAlertController(title: "Failed to load page", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alertVC.addAction(action)
        viewController.present(alertVC, animated: true)
    }
}
