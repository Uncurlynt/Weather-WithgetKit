//
//  WeatherHeaderView.swift
//  WeatherTestApp
//
//  Created by Артемий Андреев  on 22.05.2025.
//

import UIKit

final class WeatherHeaderView: UIView {
    private let cityLabel      = UILabel()
    private let conditionImage = UIImageView()
    private let tempLabel      = UILabel()
    private let hiLoLabel      = UILabel()

    init() {
        super.init(frame: .zero)
        setupViews()
    }
    required init?(coder: NSCoder) { fatalError() }

    private func setupViews() {
        let stack = UIStackView(arrangedSubviews: [
            cityLabel,
            conditionImage,
            tempLabel,
            hiLoLabel
        ])
        stack.axis      = .vertical
        stack.alignment = .center
        stack.spacing   = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        conditionImage.contentMode = .scaleAspectFit
        conditionImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            conditionImage.widthAnchor.constraint(equalToConstant: 60),
            conditionImage.heightAnchor.constraint(equalToConstant: 60)
        ])

        cityLabel.font         = .systemFont(ofSize: 34, weight: .semibold)
        cityLabel.textAlignment = .center

        tempLabel.font         = .systemFont(ofSize: 96, weight: .thin)
        tempLabel.textAlignment = .center

        hiLoLabel.font         = .systemFont(ofSize: 17)
        hiLoLabel.textAlignment = .center
    }

    func configure(with vm: HeaderViewModel) {
        cityLabel.text = vm.city
        tempLabel.text = vm.avgTemp
        hiLoLabel.text = vm.hiLo

        conditionImage.image     = UIImage(systemName: vm.symbolName)
        conditionImage.tintColor = .white
    }
}

