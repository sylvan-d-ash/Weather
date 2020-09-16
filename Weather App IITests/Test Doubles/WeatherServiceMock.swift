//
//  WeatherServiceMock.swift
//  Weather App IITests
//
//  Created by Sylvan Ash on 16/09/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

@testable import Weather_App_II

class WebServiceMock: WebService {
    enum MockError: Error {
        case failed
    }

    private(set) var didCallFetchForecast = false
    private(set) var location: String?
    var didSucceed = false

    override func fetchForecast(location: String?, completion: @escaping (Result<[Forecast], Error>) -> Void) {
        if didSucceed {
            let forecasts = WebServiceMock.getMockForecasts()
            completion(.success(forecasts))
        } else {
            let error = MockError.failed
            completion(.failure(error))
        }
    }

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
