//
//  BeersView.swift
//  BeersDemo
//

import UIKit

final class BeersView: UIView {

    lazy var collectionView = UICollectionView(frame: .zero,
                                               collectionViewLayout: createLayout())
    lazy var indicatorView = UIActivityIndicatorView(style: .medium)
    lazy var searchTextField = UITextField()

    init() {
        super.init(frame: .zero)
        nestSubviews()
        configureConstraints()
        configureViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func nestSubviews() {
        let subviews = [searchTextField, collectionView, indicatorView]

        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func startLoading() {
        collectionView.isUserInteractionEnabled = false
        searchTextField.isUserInteractionEnabled = false

        indicatorView.isHidden = false
        indicatorView.startAnimating()
    }

    func finishLoading() {
        collectionView.isUserInteractionEnabled = true
        searchTextField.isUserInteractionEnabled = true

        indicatorView.stopAnimating()
    }

    private func configureConstraints() {
        let margin: CGFloat = 8.0

        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor, constant: margin),
            searchTextField.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: margin),
            searchTextField.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -margin),
            searchTextField.heightAnchor.constraint(
                equalToConstant: 32.0),

            collectionView.leadingAnchor.constraint(
                equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(
                equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(
                equalTo: searchTextField.bottomAnchor,
                constant: margin),
            collectionView.bottomAnchor.constraint(
                equalTo: bottomAnchor),

            indicatorView.centerXAnchor.constraint(
                equalTo: centerXAnchor),
            indicatorView.centerYAnchor.constraint(
                equalTo: centerYAnchor),
        ])
    }

    private func configureViews() {
        backgroundColor = .darkGray
        collectionView.backgroundColor = .background

        searchTextField.placeholder = "Enter some food"
        searchTextField.autocorrectionType = .no
        searchTextField.backgroundColor = .background
    }

    private func createLayout() -> UICollectionViewLayout {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(40))

        let item = NSCollectionLayoutItem(layoutSize: size)

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: size, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 4, leading: 4, bottom: 4, trailing: 4)
        section.interGroupSpacing = 4

        return UICollectionViewCompositionalLayout(section: section)
    }
}

