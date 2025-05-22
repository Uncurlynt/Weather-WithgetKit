//
//  HeaderViewModel.swift
//  WeatherTestApp
//
//  Created by Артемий Андреев  on 22.05.2025.
//

import Foundation

struct HeaderViewModel {
    let city: String
    let avgTemp: String
    let hiLo: String
    let symbolName: String

    init(day: ForecastDay, city: String) {
        self.city    = city
        self.avgTemp = "\(Int(round(day.day.avgtemp_c)))°"
        self.hiLo    = "H:\(Int(day.day.maxtemp_c))°  L:\(Int(day.day.mintemp_c))°"

        symbolName = WeatherSymbol
            .from(code: day.day.condition.code)
            .systemName
    }
}
