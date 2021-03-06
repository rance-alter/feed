//
//  MainViewController.swift
//  feed
//
//  Created by Rance Tsai on 10/2/20.
//

import UIKit
import PureLayout

protocol MainViewControllerDelegate: class {
    func onLoadPageFailure(from viewController: UIViewController)
    func onTapURL(_ url: URL, from viewController: UIViewController)
}

final class MainViewController: UIViewController {
    weak var delegate: MainViewControllerDelegate?
    private let viewModel: MainViewModelProtocol
    private var nextID: Int?

    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.dataSource = self
        view.delegate = self
        view.register(StoryTableViewCell.self, forCellReuseIdentifier: StoryTableViewCell.cellIdentifier)
        view.register(LoadingTableViewCell.self, forCellReuseIdentifier: LoadingTableViewCell.cellIdentifier)
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
        viewModel.loadTopStories(id: nextID) { [weak self] nextID, error in
            DispatchQueue.main.async {
                guard let sself = self else { return }
                sself.nextID = nextID
                if error != nil {
                    sself.delegate?.onLoadPageFailure(from: sself)
                }
                sself.tableView.reloadData()
            }
        }
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.autoPinEdge(toSuperviewSafeArea: .top)
        tableView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }
}

extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < viewModel.numberOfItems else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: LoadingTableViewCell.cellIdentifier,
                for: indexPath)
            (cell as? LoadingTableViewCell)?.activityIndicator.startAnimating()
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: StoryTableViewCell.cellIdentifier,
                for: indexPath) as? StoryTableViewCell
        else {
            return UITableViewCell()
        }
        if let story = viewModel.story(at: indexPath.row) {
            cell.configure(with: StoryTableViewCellViewModel(story: story))
        }
        return cell
    }
}

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let url = viewModel.story(at: indexPath.row)?.url {
            delegate?.onTapURL(url, from: self)
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.numberOfItems - 1, nextID != nil {
            viewModel.loadTopStories(id: nextID) { [weak self] nextID, _ in
                DispatchQueue.main.async {
                    guard let sself = self else { return }
                    sself.nextID = nextID
                    tableView.reloadData()
                }
            }
        }
    }
}
