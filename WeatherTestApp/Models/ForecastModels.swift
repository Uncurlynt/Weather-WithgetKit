//
//  ForecastModels.swift
//  WeatherTestApp
//
//  Created by Артемий Андреев  on 22.05.2025.
//

import Foundation

struct ForecastResponse: Decodable {
    let forecast: Forecast
}

struct Forecast: Decodable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Decodable {
    let date: String
    let day: Day
    let astro: Astro
}

struct Day: Decodable {
    let maxtemp_c: Double
    let mintemp_c: Double
    let avgtemp_c: Double
    let maxwind_kph: Double
    let avghumidity: Double
    let daily_chance_of_rain: Int?
    let uv: Double?
    let condition: Condition
}

struct Condition: Decodable {
    let text: String
    let icon: String
    let code: Int
}

struct Astro: Decodable {
    let sunrise: String
    let sunset: String
}
