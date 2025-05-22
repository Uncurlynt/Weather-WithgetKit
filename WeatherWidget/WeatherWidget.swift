//
//  WeatherWidget.swift
//  WeatherWidget
//
//  Created by Артемий Андреев  on 22.05.2025.
//

import WidgetKit
import SwiftUI
import Foundation

private let groupID = "group.Artemii.WeatherTestApp"

// MARK: — TimelineEntry

struct WeatherEntry: TimelineEntry {
    let date: Date
    let city: String
    let temperature: String
    let iconSymbol: String
}

// MARK: — TimelineProvider

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WeatherEntry {
        WeatherEntry(
            date: Date(),
            city: "City",
            temperature: "--°",
            iconSymbol: "cloud"
        )
    }

    func getSnapshot(in context: Context,
                     completion: @escaping (WeatherEntry) -> Void) {
        let entry = WeatherEntry(
            date: Date(),
            city: "Moscow",
            temperature: "0°",
            iconSymbol: "sun.max"
        )
        completion(entry)
    }

    func getTimeline(in context: Context,
                     completion: @escaping (Timeline<WeatherEntry>) -> Void) {
        let defaults       = UserDefaults(suiteName: groupID)
        let city           = defaults?.string(forKey: "lastCity")       ?? "—"
        let temp           = defaults?.string(forKey: "lastTemp")       ?? "--°"
        let symbol         = defaults?.string(forKey: "lastIconSymbol") ?? "cloud"

        let entry = WeatherEntry(
            date: Date(),
            city: city,
            temperature: temp,
            iconSymbol: symbol
        )

        let nextUpdate = Calendar.current.date(
            byAdding: .hour,
            value: 1,
            to: Date()
        )!

        let timeline = Timeline(
            entries: [entry],
            policy: .after(nextUpdate)
        )
        completion(timeline)
    }
}

// MARK: — SwiftUI View

struct WeatherWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue, .purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            VStack(spacing: 8) {
                Text(entry.city)
                    .font(.headline)
                    .foregroundColor(.white)

                Image(systemName: entry.iconSymbol)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)

                Text(entry.temperature)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
            }
            .padding()
        }
    }
}

// MARK: — Widget Configurate

struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()
        ) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Weather Widget")
        .description("Показывает текущую погоду.")
        .supportedFamilies([.systemSmall])
    }
}

// MARK: — Preview

struct WeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        WeatherWidgetEntryView(
            entry: WeatherEntry(
                date: Date(),
                city: "Moscow",
                temperature: "0°",
                iconSymbol: "sun.max"
            )
        )
        .previewContext(
            WidgetPreviewContext(family: .systemSmall)
        )
    }
}
