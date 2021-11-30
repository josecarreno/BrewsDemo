//
//  BeerDetailViewController.swift
//  BeersDemo
//

import UIKit
import Combine
import Kingfisher

final class BeerDetailViewController: UIViewController {

    private lazy var contentView = BeerDetailView()

    private var viewModel: BeerDetailViewModel!
    
    private var bindings = Set<AnyCancellable>()

    init(viewModel: BeerDetailViewModel) {
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
        super.viewDidLoad()

        bindViewModelToView()
        // View to viewmodel binding is not needed
        // (there is no user interaction on this screen)
    }

    func bindViewModelToView() {
        viewModel.$name
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                self?.contentView.nameLabel.text = value
            })
            .store(in: &bindings)

        viewModel.$tagline
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                self?.contentView.tagLabel.text = value
            })
            .store(in: &bindings)

        viewModel.$imageURL
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                guard let url = value else { return }
                self?.contentView.imageView.kf.setImage(with: url)
            })
            .store(in: &bindings)

        viewModel.$description
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                self?.contentView.descriptionLabel.text = value
            })
            .store(in: &bindings)
    }
}
