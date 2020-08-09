//
//  CacheService.swift
//  Weather App II
//
//  Created by Sylvan Ash on 09/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import Foundation

enum CacheError: Error {
    case noCache
}

class CacheService: DataServiceProtocol {
    func fetchForecast(location: String?, completion: @escaping (Result<[Forecast], Error>) -> Void) {
        guard let url = Bundle.main.url(forResource: "forecast", withExtension: "json") else {
            completion(.failure(CacheError.noCache))
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let forecast = try JSONDecoder().decode(ForecastList.self, from: data)
            completion(.success(forecast.list))
        } catch {
            completion(.failure(error))
        }
    }
}
