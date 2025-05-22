//
//  ForecastDayViewModel.swift
//  WeatherTestApp
//
//  Created by Артемий Андреев  on 22.05.2025.
//

import UIKit

struct ForecastDayViewModel {
    let weekday: String
    let chanceOfRain: String
    let minTemp: String
    let maxTemp: String
    let symbolName: String
    let lowFactor: CGFloat
    let highFactor: CGFloat

    let avgTemp: String
    let wind: String
    let humidity: String
    let rainChance: String
    let uvIndex: String
    let sunriseSunset: String

    init(from day: ForecastDay, overallMin: Double, overallMax: Double) {
        let isoDF = DateFormatter()
        isoDF.dateFormat = "yyyy-MM-dd"
        let weekdayDF = DateFormatter()
        weekdayDF.locale = Locale(identifier: "en_US_POSIX")
        weekdayDF.dateFormat = "E"
        let date = isoDF.date(from: day.date) ?? Date()
        let symbol = weekdayDF.string(from: date)
        weekday = Calendar.current.isDateInToday(date)
            ? "Today"
            : String(symbol.prefix(2)).capitalized

        chanceOfRain = "\(day.day.daily_chance_of_rain ?? 0)%"
        minTemp       = "\(Int(day.day.mintemp_c))°"
        maxTemp       = "\(Int(day.day.maxtemp_c))°"

        symbolName = WeatherSymbol
            .from(code: day.day.condition.code)
            .systemName

        let span = overallMax - overallMin
        if span > 0 {
            lowFactor  = CGFloat((day.day.mintemp_c - overallMin) / span)
            highFactor = CGFloat((day.day.maxtemp_c - overallMin) / span)
        } else {
            lowFactor  = 0
            highFactor = 1
        }

        avgTemp       = "\(Int(round(day.day.avgtemp_c)))°"
        wind          = "\(Int(round(day.day.maxwind_kph))) kph"
        humidity      = "\(Int(round(day.day.avghumidity))) %"
        rainChance    = "\(day.day.daily_chance_of_rain ?? 0)%"
        uvIndex       = day.day.uv.map { String(format: "%.1f", $0) } ?? "--"
        sunriseSunset = "\(day.astro.sunrise) / \(day.astro.sunset)"
    }
}
