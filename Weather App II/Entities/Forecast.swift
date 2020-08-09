//
//  Forecast.swift
//  Weather App II
//
//  Created by Sylvan Ash on 09/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import Foundation

struct Forecast: Decodable {
    struct Main: Decodable {
        let temp: Double
        let minTemp: Double
        let maxTemp: Double

        private enum CodingKeys: String, CodingKey {
            case temp
            case minTemp = "temp_min"
            case maxTemp = "temp_max"
        }
    }

    struct Weather: Decodable {
        let icon: String
        let description: String
        let id: Int
    }

    let main: Main
    let weather: [Weather]
    let time: Date

    private enum CodingKeys: String, CodingKey {
        case main, weather
        case time = "dt"
    }
}

extension Forecast {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        main = try container.decode(Main.self, forKey: .main)
        weather = try container.decode([Weather].self, forKey: .weather)

        let datetime = try container.decode(Int.self, forKey: .time)
        time = Date(timeIntervalSince1970: TimeInterval(datetime))
    }
}
