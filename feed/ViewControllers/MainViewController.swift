//
//  MainViewController.swift
//  feed
//
//  Created by Rance Tsai on 10/2/20.
//

import UIKit

final class MainViewController: UIViewController {
    private let viewModel: MainViewModelProtocol

    init(viewModel: MainViewModelProtocol = MainViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadTopStories { error in
            // TODO
        }
    }
}
