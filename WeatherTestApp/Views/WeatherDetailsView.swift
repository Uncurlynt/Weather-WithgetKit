//
//  WeatherDetailsView.swift
//  WeatherTestApp
//
//  Created by Артемий Андреев  on 22.05.2025.
//

import UIKit

protocol WeatherDetailsViewDelegate: AnyObject {
    func detailsView(_ view: WeatherDetailsView, didSelect index: Int)
}

final class WeatherDetailsView: UIView {

    // MARK: — Delegate
    weak var delegate: WeatherDetailsViewDelegate?

    // MARK: — UI Components
    private let forecastCard = SectionCardView()

    private let headerStack: UIStackView = {
        let icon = UIImageView(image: UIImage(systemName: "calendar"))
        icon.tintColor = .secondaryLabel
        icon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 16),
            icon.heightAnchor.constraint(equalToConstant: 16)
        ])

        let title = UILabel()
        title.text = "Прогноз на 5 дней"
        title.font = .systemFont(ofSize: 13, weight: .semibold)
        title.textColor = .secondaryLabel

        let stack = UIStackView(arrangedSubviews: [icon, title])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true
        return view
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection    = .vertical
        layout.minimumLineSpacing = 0
        layout.sectionInset       = .zero
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(DayCell.self, forCellWithReuseIdentifier: DayCell.reuseID)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    private var collectionHeightConstraint: NSLayoutConstraint!

    private let gridStack: UIStackView = {
        let vs = UIStackView()
        vs.axis = .vertical
        vs.spacing = 12
        vs.translatesAutoresizingMaskIntoConstraints = false
        return vs
    }()

    private var infoCards: [InfoCardView] = []
    private var viewModels: [ForecastDayViewModel] = []

    // MARK: — Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    // MARK: — Setup
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(forecastCard)
        forecastCard.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            forecastCard.topAnchor.constraint(equalTo: topAnchor),
            forecastCard.leadingAnchor.constraint(equalTo: leadingAnchor),
            forecastCard.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        let content = forecastCard.contentView
        content.addSubview(headerStack)
        content.addSubview(separator)
        content.addSubview(collectionView)

        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: content.topAnchor),
            headerStack.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            headerStack.trailingAnchor.constraint(equalTo: content.trailingAnchor),

            separator.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 8),
            separator.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: content.trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: content.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: content.bottomAnchor)
        ])

        collectionHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 0)
        collectionHeightConstraint.isActive = true

        collectionView.dataSource = self
        collectionView.delegate   = self

        addSubview(gridStack)
        NSLayoutConstraint.activate([
            gridStack.topAnchor.constraint(equalTo: forecastCard.bottomAnchor, constant: 16),
            gridStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            gridStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            gridStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        let definitions: [(icon: String, title: String)] = [
            ("thermometer.medium", "Feels like"),
            ("wind",               "Wind"),
            ("drop.fill",          "Humidity"),
            ("umbrella.percent",   "Rain chance"),
            ("sun.max",            "UV index"),
            ("sunrise.fill",       "Sunrise / Sunset")
        ]
        infoCards = definitions.map { InfoCardView(systemName: $0.icon, title: $0.title) }

        for i in stride(from: 0, to: infoCards.count, by: 2) {
            let row = Array(infoCards[i..<min(i+2, infoCards.count)])
            let hstack = UIStackView(arrangedSubviews: row)
            hstack.axis         = .horizontal
            hstack.spacing      = 12
            hstack.distribution = .fillEqually
            hstack.translatesAutoresizingMaskIntoConstraints = false
            gridStack.addArrangedSubview(hstack)
        }
    }

    // MARK: — Configure
    func configure(with vms: [ForecastDayViewModel], selectedIndex: Int = 0) {
        self.viewModels = vms
        collectionView.reloadData()

        collectionHeightConstraint.constant = CGFloat(vms.count) * 52
        layoutIfNeeded()

        bindInfoCardData(at: selectedIndex)
    }

    private func bindInfoCardData(at index: Int) {
        let vm = viewModels[index]
        infoCards[0].configure(value: vm.avgTemp)
        infoCards[1].configure(value: vm.wind)
        infoCards[2].configure(value: vm.humidity)
        infoCards[3].configure(value: vm.rainChance)
        infoCards[4].configure(value: vm.uvIndex)
        infoCards[5].configure(value: vm.sunriseSunset)
    }
}

// MARK: — UICollectionViewDataSource & DelegateFlowLayout

extension WeatherDetailsView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ cv: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }

    func collectionView(_ cv: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(
            withReuseIdentifier: DayCell.reuseID,
            for: indexPath
        ) as! DayCell
        let isLast = indexPath.item == viewModels.count - 1
                cell.configure(
                    with: viewModels[indexPath.item],
                    showSeparator: !isLast
                )
                return cell
            }


    func collectionView(_ cv: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        bindInfoCardData(at: indexPath.item)
        delegate?.detailsView(self, didSelect: indexPath.item)
    }

    func collectionView(_ cv: UICollectionView,
                        layout layout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flow = layout as! UICollectionViewFlowLayout
        let width = cv.bounds.width - flow.sectionInset.left - flow.sectionInset.right
        return CGSize(width: width, height: 52)
    }
}
