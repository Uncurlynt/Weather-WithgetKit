//
//  WeatherIconMapper.swift
//  WeatherTestApp
//
//  Created by Артемий Андреев  on 23.05.2025.
//

import Foundation

enum WeatherSymbol {
    case sun
    case cloudSun
    case cloud
    case cloudFog
    case cloudRain
    case cloudHeavyRain
    case boltRain
    case snow
    case snowHeavy
    case question

    var systemName: String {
        switch self {
        case .sun:            return "sun.max"
        case .cloudSun:       return "cloud.sun"
        case .cloud:          return "cloud"
        case .cloudFog:       return "cloud.fog"
        case .cloudRain:      return "cloud.rain"
        case .cloudHeavyRain: return "cloud.heavyrain"
        case .boltRain:       return "cloud.bolt.rain"
        case .snow:           return "snow"
        case .snowHeavy:      return "snow"
        case .question:       return "questionmark"
        }
    }

    static func from(code: Int) -> WeatherSymbol {
        switch code {
        // Clear / Sunny
        case 1000:
            return .sun

        // Partly cloudy
        case 1003:
            return .cloudSun

        // Cloudy / Overcast
        case 1006, 1009:
            return .cloud

        // Mist / Fog
        case 1030, 1135, 1147:
            return .cloudFog


        // Patchy snow/sleet/freezing drizzle
        case 1066, 1069, 1072, 1063,
             1150, 1153, 1168, 1171,
             1180, 1183, 1186, 1189:
            return .cloudRain

        // Freezing rain
        case 1198, 1201,1192, 1195:
            return .cloudHeavyRain

        // Patchy snow / snow showers
        case 1210, 1213, 1216, 1219, 1222, 1225,
             1204, 1207, 1249, 1252, 1261, 1264,
             1237, 1255, 1258:
            return .snow

        // Torrential rain shower
        case 1246:
            return .cloudHeavyRain

        // Light rain shower
        case 1240, 1243:
            return .cloudRain

        // Thunder / Storm
        case 1087, 1273, 1276, 1279, 1282:
            return .boltRain

        // Всё остальное
        default:
            return .question
        }
    }
}

