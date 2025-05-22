//
//  WeatherService.swift
//  WeatherTestApp
//
//  Created by Артемий Андреев  on 22.05.2025.
//

import Foundation

enum WeatherServiceError: LocalizedError {
    case apiKeyMissing
    case badURL

    var errorDescription: String? {
        switch self {
        case .apiKeyMissing: return "API-ключ не найден (WEATHER_API_KEY)."
        case .badURL:        return "Не удалось сформировать запрос."
        }
    }
}

struct WeatherService {
    private let baseURL = "https://api.weatherapi.com/v1/forecast.json"
    private var apiKey: String {
        Bundle.main.infoDictionary?["WEATHER_API_KEY"] as? String ?? ""
    }

    func fetchForecast(for city: String, days: Int = 5) async throws -> [ForecastDay] {
        guard !apiKey.isEmpty else { throw WeatherServiceError.apiKeyMissing }
        var comp = URLComponents(string: baseURL)!
        comp.queryItems = [
            .init(name: "key",    value: apiKey),
            .init(name: "q",      value: city),
            .init(name: "days",   value: "\(days)"),
            .init(name: "aqi",    value: "no"),
            .init(name: "alerts", value: "no")
        ]
        guard let url = comp.url else { throw WeatherServiceError.badURL }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(ForecastResponse.self, from: data)
        return decoded.forecast.forecastday
    }
}
