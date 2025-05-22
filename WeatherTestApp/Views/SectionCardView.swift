//
//  SectionCardView.swift
//  WeatherTestApp
//
//  Created by Артемий Андреев  on 22.05.2025.
//

import UIKit

class SectionCardView: UIView {

    let contentView = UIView()

    init() {
        super.init(frame: .zero)
        setup()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setup() {
        layer.cornerRadius = 18
        layer.masksToBounds = true

        let blur = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.clipsToBounds = true

        addSubview(blurView)
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        contentView.translatesAutoresizingMaskIntoConstraints = false
        blurView.contentView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: blurView.contentView.topAnchor, constant: 12),
            contentView.leadingAnchor.constraint(equalTo: blurView.contentView.leadingAnchor, constant: 12),
            contentView.trailingAnchor.constraint(equalTo: blurView.contentView.trailingAnchor, constant: -12),
            contentView.bottomAnchor.constraint(equalTo: blurView.contentView.bottomAnchor, constant: -12)
        ])
    }
}
