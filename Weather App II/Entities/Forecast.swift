//
//  Forecast.swift
//  Weather App II
//
//  Created by Sylvan Ash on 09/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import Foundation

struct ForecastList: Decodable {
    let list: [Forecast]
}

struct Forecast: Decodable {
    struct Weather: Decodable {
        let icon: String
        let description: String
        let id: Int
    }

    var temp: Double = 0
    var time: Date = Date()
    let weather: [Weather]

    private enum CodingKeys: String, CodingKey {
        case main, weather
        case time = "dt"

        enum MainKeys: String, CodingKey {
            case temp
        }
    }
}

extension Forecast {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        weather = try container.decode([Forecast.Weather].self, forKey: .weather)

        let mainContainer = try container.nestedContainer(keyedBy: CodingKeys.MainKeys.self, forKey: .main)
        temp = try mainContainer.decode(Double.self, forKey: .temp)

        let datetime = try container.decode(Int.self, forKey: .time)
        time = Date(timeIntervalSince1970: TimeInterval(datetime))
    }
}
