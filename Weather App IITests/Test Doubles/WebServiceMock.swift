//
//  WeatherServiceMock.swift
//  Weather App IITests
//
//  Created by Sylvan Ash on 16/09/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

@testable import Weather_App_II

class WebServiceMock: WebService {
    private(set) var didCallFetchForecast = false
    private(set) var location: String?
    var didSucceed = false

    override func fetchForecast(location: String?, completion: @escaping (Result<[Forecast], Error>) -> Void) {
        if didSucceed {
            let forecasts = DataHelper.getMockForecasts()
            completion(.success(forecasts))
        } else {
            let error = MockError.failed
            completion(.failure(error))
        }
    }
}
