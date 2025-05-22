//
//  DayCell.swift
//  WeatherTestApp
//
//  Created by Артемий Андреев on 22.05.2025.
//

import UIKit

final class DayCell: UICollectionViewCell {
    static let reuseID = "DayCell"

    // MARK: – UI Elements
    private let weekdayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 70).isActive = true
        return label
    }()

    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iv.widthAnchor.constraint(equalToConstant: 24),
            iv.heightAnchor.constraint(equalToConstant: 24)
        ])
        return iv
    }()

    private let chanceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let loLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return label
    }()

    private let trackView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGray5
        v.layer.cornerRadius = 2
        v.translatesAutoresizingMaskIntoConstraints = false
        v.heightAnchor.constraint(equalToConstant: 4).isActive = true
        return v
    }()

    private let rangeView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 2
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let hiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: 30).isActive = true
        return label
    }()

    private let separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = .separator
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private var leadingC: NSLayoutConstraint!
    private var trailingC: NSLayoutConstraint!
    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = rangeView.bounds
    }

    // MARK: – Elevation Animation
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.2) {
            self.contentView.layer.shadowColor   = UIColor.black.cgColor
            self.contentView.layer.shadowOpacity = 0.2
            self.contentView.layer.shadowOffset  = CGSize(width: 0, height: 4)
            self.contentView.layer.shadowRadius  = 6
            self.contentView.transform           = CGAffineTransform(translationX: 0, y: -4)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.2) {
            self.contentView.layer.shadowOpacity = 0
            self.contentView.transform           = .identity
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.2) {
            self.contentView.layer.shadowOpacity = 0
            self.contentView.transform           = .identity
        }
    }

    // MARK: – Setup Views
    private func setupViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.layer.masksToBounds = false

        let iconStack = UIStackView(arrangedSubviews: [iconView, chanceLabel])
        iconStack.axis = .vertical
        iconStack.alignment = .center
        iconStack.spacing = 2
        iconStack.translatesAutoresizingMaskIntoConstraints = false
        iconStack.widthAnchor.constraint(equalToConstant: 40).isActive = true

        trackView.addSubview(rangeView)
        leadingC = rangeView.leadingAnchor.constraint(equalTo: trackView.leadingAnchor)
        trailingC = rangeView.trailingAnchor.constraint(equalTo: trackView.trailingAnchor)
        NSLayoutConstraint.activate([
            leadingC,
            trailingC,
            rangeView.topAnchor.constraint(equalTo: trackView.topAnchor),
            rangeView.bottomAnchor.constraint(equalTo: trackView.bottomAnchor)
        ])

        let coldColor  = UIColor(named: "ColdWeather")?.cgColor  ?? UIColor.systemBlue.cgColor
        let warmColor  = UIColor(named: "WarmWeather")?.cgColor  ?? UIColor.systemOrange.cgColor
        gradientLayer.colors     = [coldColor, warmColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint   = CGPoint(x: 1, y: 0.5)
        rangeView.layer.insertSublayer(gradientLayer, at: 0)

        let hStack = UIStackView(arrangedSubviews: [
            weekdayLabel,
            iconStack,
            loLabel,
            trackView,
            hiLabel
        ])
        hStack.axis      = .horizontal
        hStack.alignment = .center
        hStack.spacing   = 12
        hStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(hStack)
        contentView.addSubview(separatorView)

        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    // MARK: – Configure Cell
    func configure(with vm: ForecastDayViewModel, showSeparator: Bool) {
        weekdayLabel.text = vm.weekday
        chanceLabel.text  = vm.chanceOfRain
        loLabel.text      = vm.minTemp
        hiLabel.text      = vm.maxTemp

        contentView.layoutIfNeeded()
        let width = trackView.bounds.width
        leadingC.constant  = width * vm.lowFactor
        trailingC.constant = -width * (1 - vm.highFactor)
        contentView.layoutIfNeeded()

        iconView.image = UIImage(systemName: vm.symbolName)
        iconView.tintColor = .label

        separatorView.isHidden = !showSeparator
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        iconView.image = nil
        contentView.layer.shadowOpacity = 0
        contentView.transform = .identity
    }
}
