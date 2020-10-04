//
//  MainViewController.swift
//  feed
//
//  Created by Rance Tsai on 10/2/20.
//

import UIKit

private enum Section {
    case topStories
}

protocol MainViewControllerDelegate: class {
    func onLoadPageFailure(from viewController: UIViewController)
}

final class MainViewController: UIViewController {
    weak var delegate: MainViewControllerDelegate?
    private let viewModel: MainViewModelProtocol

    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.dataSource = self
        view.delegate = self
        view.register(StoryTableViewCell.self, forCellReuseIdentifier: StoryTableViewCell.cellIdentifier)
        return view
    }()

    init(viewModel: MainViewModelProtocol = MainViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        viewModel.loadTopStories { [weak self] error in
            DispatchQueue.main.async {
                guard let sself = self else { return }
                if error != nil {
                    sself.delegate?.onLoadPageFailure(from: sself)
                } else {
                    sself.tableView.reloadData()
                }
            }
        }
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: StoryTableViewCell.cellIdentifier,
                for: indexPath) as? StoryTableViewCell
        else { return UITableViewCell() }

        if let story = viewModel.story(at: indexPath.row) {
            cell.configure(with: StoryTableViewCellViewModel(story: story))

            if !story.isLoaded {
                viewModel.loadStory(story) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case let .success(value):
                            if value == story {
                                tableView.reloadRows(at: [indexPath], with: .automatic)
                            }
                        case let .failure(error):
                            if let error = error as? MainViewModelError, error == .hiddenItem {
                                tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
