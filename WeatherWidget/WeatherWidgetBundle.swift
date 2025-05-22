//
//  WeatherWidgetBundle.swift
//  WeatherWidget
//
//  Created by Артемий Андреев  on 22.05.2025.
//

import WidgetKit
import SwiftUI

@main
struct WeatherWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        WeatherWidget()
    }
}
