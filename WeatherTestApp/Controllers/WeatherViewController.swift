//
//  WeatherViewController.swift
//  WeatherTestApp
//
//  Created by Артемий Андреев  on 22.05.2025.
//

import UIKit
import WidgetKit

final class WeatherViewController: UIViewController {
    
    // MARK: – Gradient Background
    private let backgroundGradient = CAGradientLayer()
    private var skyTop: UIColor    { UIColor(named: "skyTop")    ?? .systemBlue }
    private var skyBottom: UIColor { UIColor(named: "skyBottom") ?? .systemPurple }

    // MARK: – Model & ViewModels
    private let service     = WeatherService()
    private var days: [ForecastDay] = []
    private var dayVMs: [ForecastDayViewModel] = []
    private var currentCity: String = ""

    // MARK: – Views
    private let headerView  = WeatherHeaderView()
    private let detailsView = WeatherDetailsView()
    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: – Layout
    private let scrollView   = UIScrollView()
    private let contentStack = UIStackView()

    // MARK: – Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        detailsView.delegate = self

        Task {
            await loadForecast(for: "Moscow")
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        backgroundGradient.frame = view.bounds
        backgroundGradient.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY)

        if backgroundGradient.animation(forKey: "startPointAnim") == nil {
            animateGradientFlow()
        }
    }

    // MARK: – UI Setup
    private func setupUI() {
        backgroundGradient.colors     = [skyTop.cgColor, skyBottom.cgColor]
        backgroundGradient.startPoint = CGPoint(x: 0, y: 0)
        backgroundGradient.endPoint   = CGPoint(x: 1, y: 1)

        backgroundGradient.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        view.layer.insertSublayer(backgroundGradient, at: 0)

        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search city"

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.layer.cornerRadius = 18
        scrollView.clipsToBounds = true

        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)

        contentStack.addArrangedSubview(headerView)
        contentStack.addArrangedSubview(detailsView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func animateGradientFlow() {
        let center = CGPoint(x: 0.5, y: 0.5)
        let radius: CGFloat = 0.5
        let steps = 100

        var startValues = [NSValue]()
        var endValues   = [NSValue]()

        for i in 0...steps {
            let angle = CGFloat(i) / CGFloat(steps) * (.pi * 2)
            let sx = center.x + cos(angle) * radius
            let sy = center.y + sin(angle) * radius
            let ex = center.x - cos(angle) * radius
            let ey = center.y - sin(angle) * radius

            startValues.append(NSValue(cgPoint: CGPoint(x: sx, y: sy)))
            endValues.append  (NSValue(cgPoint: CGPoint(x: ex, y: ey)))
        }

        // Анимация для startPoint
        let startAnim = CAKeyframeAnimation(keyPath: "startPoint")
        startAnim.values        = startValues
        startAnim.duration      = 30
        startAnim.repeatCount   = .infinity
        startAnim.calculationMode = .paced

        // Анимация для endPoint
        let endAnim = CAKeyframeAnimation(keyPath: "endPoint")
        endAnim.values          = endValues
        endAnim.duration        = 30
        endAnim.repeatCount     = .infinity
        endAnim.calculationMode = .paced

        backgroundGradient.add(startAnim, forKey: "startPointAnim")
        backgroundGradient.add(endAnim,   forKey: "endPointAnim")
    }

    // MARK: – Loading Data
    @MainActor
    private func loadForecast(for city: String) async {
        currentCity = city.capitalized
        do {
            let fetched = try await service.fetchForecast(for: city)
            days = fetched

            let allMins = fetched.map { $0.day.mintemp_c }
            let allMaxs = fetched.map { $0.day.maxtemp_c }
            let overallMin = allMins.min() ?? 0
            let overallMax = allMaxs.max() ?? 0

            dayVMs = fetched.map {
                ForecastDayViewModel(
                    from: $0,
                    overallMin: overallMin,
                    overallMax: overallMax
                )
            }

            if let today = fetched.first {
                cacheTodayWeather(today, city: currentCity)
            }

            let headerVM = HeaderViewModel(day: fetched[0], city: currentCity)
            headerView.configure(with: headerVM)
            detailsView.configure(with: dayVMs)
        } catch {
            presentAlert(error)
        }
    }

    private func cacheTodayWeather(_ today: ForecastDay, city: String) {
        let defaults = UserDefaults(suiteName: "group.Artemii.WeatherTestApp")
        defaults?.set(city, forKey: "lastCity")
        defaults?.set("\(Int(round(today.day.avgtemp_c)))°", forKey: "lastTemp")
        let symbol = WeatherSymbol
            .from(code: today.day.condition.code)
            .systemName
        defaults?.set(symbol, forKey: "lastIconSymbol")
        defaults?.synchronize()
        WidgetCenter.shared.reloadAllTimelines()
    }

    @MainActor
    private func presentAlert(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: – UISearchBarDelegate
extension WeatherViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ sb: UISearchBar) {
        guard let text = sb.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty
        else { return }

        searchController.isActive = false
        Task { await loadForecast(for: text) }
    }
}

// MARK: – WeatherDetailsViewDelegate

extension WeatherViewController: WeatherDetailsViewDelegate {
    func detailsView(_ view: WeatherDetailsView, didSelect index: Int) {
        let headerVM = HeaderViewModel(day: days[index], city: currentCity)
        headerView.configure(with: headerVM)
    }
}
