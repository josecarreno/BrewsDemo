//
//  BeersViewController.swift
//  BeersDemo
//

import UIKit
import Combine

final class BeersViewController: UIViewController {
    private typealias DataSource =
        UICollectionViewDiffableDataSource<BeersViewModel.Section, Beer>
    private typealias Snapshot =
        NSDiffableDataSourceSnapshot<BeersViewModel.Section, Beer>

    private lazy var contentView = BeersView()
    private let viewModel: BeersViewModel
    private var bindings = Set<AnyCancellable>()

    private var dataSource: DataSource!

    init(viewModel: BeersViewModel = BeersViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        setUpTableView()
        configureDataSource()
        setUpBindings()

        self.navigationItem.title = "What can i drink?"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.retrySearch()
    }

    private func setUpTableView() {
        contentView.collectionView.register(
            BeerCollectionCell.self,
            forCellWithReuseIdentifier: BeerCollectionCell.identifier)
    }

    private func setUpBindings() {
        func bindViewToViewModel() {
            contentView.searchTextField.textPublisher
                .debounce(for: 0.5, scheduler: DispatchQueue.main)
                .removeDuplicates()
                .sink { [weak viewModel] in
                    viewModel?.search(query: $0)
                }
                .store(in: &bindings)
        }

        func bindViewModelToView() {
            viewModel.$beers
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] _ in
                    self?.updateSections()
                })
                .store(in: &bindings)

            let stateValueHandler: (BeersViewModelState) -> Void =
                { [weak self] state in
                    switch state {
                    case .loading:
                        self?.contentView.startLoading()
                    case .finishedLoading:
                        self?.contentView.finishLoading()
                    case .error(let error):
                        self?.contentView.finishLoading()
                        self?.showError(error)
                    }
                }

            viewModel.$state
                .receive(on: RunLoop.main)
                .sink(receiveValue: stateValueHandler)
                .store(in: &bindings)
        }

        bindViewToViewModel()
        bindViewModelToView()
    }

    private func showError(_ error: Error) {
        let alertController = UIAlertController(title: "Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        let alertAction = UIAlertAction(
            title: "OK", style: .default) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(alertAction)

        present(alertController, animated: true, completion: nil)
    }

    private func updateSections() {
        var snapshot = Snapshot()
        snapshot.appendSections([.beers])
        snapshot.appendItems(viewModel.beers)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension BeersViewController {
    private func configureDataSource() {
        dataSource = DataSource(
            collectionView: contentView.collectionView,
            cellProvider: { (collectionView, indexPath, beer)
                -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: BeerCollectionCell.identifier,
                    for: indexPath) as? BeerCollectionCell

                cell?.viewModel = BeerCellViewModel(beer: beer)
                cell?.detailButton.replaceAction { [weak self] in
                    let viewModel = BeerDetailViewModel(beer: beer)
                    let viewcontroller = BeerDetailViewController(viewModel: viewModel)

                    self?.navigationController?.pushViewController(
                        viewcontroller, animated: true)
                }

                return cell
            })
    }
}
