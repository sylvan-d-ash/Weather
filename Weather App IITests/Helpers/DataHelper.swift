//
//  DataHelper.swift
//  Weather App IITests
//
//  Created by Sylvan Ash on 16/09/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

@testable import Weather_App_II

enum MockError: Error {
    case failed
}

class DataHelper {
    static func getMockForecasts() -> [Forecast] {
        let weather = Forecast.Weather(icon: "none", description: "Sunny", id: 1)
        var forecasts = [Forecast]()
        for i in 0..<10 {
            let forecast = Forecast(temp: Double(i), weather: [weather])
            forecasts.append(forecast)
        }
        return forecasts
    }
}
