//
//  AppCoordinator.swift
//  feed
//
//  Created by Rance Tsai on 10/2/20.
//

import UIKit
import SafariServices

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

    func onTapURL(_ url: URL, from viewController: UIViewController) {
        let safariVC = SFSafariViewController(url: url)
        viewController.present(safariVC, animated: true)
    }
}
