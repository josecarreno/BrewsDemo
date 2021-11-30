//
//  BeerDetailView.swift
//  BeersDemo
//

import UIKit
final class BeerDetailView: UIView {

    lazy var nameLabel = UILabel()
    lazy var tagLabel = UILabel()
    lazy var imageView = UIImageView()
    lazy var descriptionLabel = UILabel()

    init() {
        super.init(frame: .zero)

        backgroundColor = .background
        nestSubviews()
        configureConstraints()
        configureViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func nestSubviews() {
        let subviews = [nameLabel, tagLabel, imageView, descriptionLabel]

        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }


    private func configureConstraints() {
        let margin: CGFloat = 8.0

        // Could use a stackView if this view gets more complicated
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor, constant: margin),
            nameLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: margin),
            nameLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -margin),

            tagLabel.topAnchor.constraint(
                equalTo: nameLabel.bottomAnchor, constant: margin),
            tagLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: margin),
            tagLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -margin),

            imageView.topAnchor.constraint(
                equalTo: tagLabel.bottomAnchor, constant: margin),
            imageView.centerXAnchor.constraint(
                equalTo: centerXAnchor),
            imageView.heightAnchor.constraint(
                equalToConstant: 128),
            imageView.widthAnchor.constraint(
                equalToConstant: 128),

            descriptionLabel.topAnchor.constraint(
                equalTo: imageView.bottomAnchor, constant: margin * 3),
            descriptionLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: margin),
            descriptionLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -margin),
        ])
    }

    private func configureViews() {
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center

        tagLabel.font = .systemFont(ofSize: 14, weight: .thin)
        tagLabel.numberOfLines = 0
        tagLabel.textAlignment = .center

        imageView.contentMode = .scaleAspectFit

        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .justified
    }
}
