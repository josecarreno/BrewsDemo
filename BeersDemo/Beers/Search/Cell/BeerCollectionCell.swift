//
//  BeerCollectionCell.swift
//  BeersDemo
//

import UIKit
import Combine

final class BeerCollectionCell: UICollectionViewCell {
    static let identifier = "BeerCollectionCell"

    var viewModel: BeerCellViewModel! {
        didSet { configureViewModel() }
    }

    lazy var nameLabel = UILabel()
    lazy var detailImage = UIImageView(
        image: .init(systemName: "arrow.right"))
    lazy var detailButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        nestSubviews()
        configureConstraints()

        detailImage.tintColor = .black
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func nestSubviews() {
        let subviews = [nameLabel, detailImage, detailButton]

        subviews.forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 8.0),
            nameLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 8.0),
            nameLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -8.0),

            detailImage.centerYAnchor.constraint(
                equalTo: nameLabel.centerYAnchor),
            detailImage.widthAnchor.constraint(
                equalToConstant: 16),
            detailImage.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -8.0),
            detailImage.heightAnchor.constraint(
                equalToConstant: 16),

            detailButton.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 8.0),
            detailButton.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 8.0),
            detailButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -8.0),
            detailButton.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -8.0),
        ])
    }

    private func configureViewModel() {
        nameLabel.text = viewModel.name
    }
}

