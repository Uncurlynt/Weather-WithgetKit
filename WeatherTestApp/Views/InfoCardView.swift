//
//  InfoCardView.swift
//  WeatherTestApp
//
//  Created by Артемий Андреев  on 22.05.2025.
//

import UIKit

final class InfoCardView: SectionCardView {
    private let iconView   = UIImageView()
    private let valueLabel = UILabel()
    private let titleLabel = UILabel()

    init(systemName: String, title: String) {
        super.init()
        setupViews(systemName: systemName, title: title)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupViews(systemName: String, title: String) {
        iconView.image = UIImage(systemName: systemName)
        iconView.tintColor   = .label
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20)
        ])

        valueLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        valueLabel.textAlignment = .center

        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .secondaryLabel
        titleLabel.textAlignment = .center

        let vstack = UIStackView(arrangedSubviews: [iconView, valueLabel, titleLabel])
        vstack.axis = .vertical
        vstack.alignment = .center
        vstack.spacing = 8
        vstack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(vstack)
        NSLayoutConstraint.activate([
            vstack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            vstack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            vstack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            vstack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
        ])
    }

    func configure(value: String) {
        valueLabel.text = value
    }
}

