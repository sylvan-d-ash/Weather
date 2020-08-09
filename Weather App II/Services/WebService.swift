//
//  Webservice.swift
//  Weather App II
//
//  Created by Sylvan Ash on 09/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import Foundation

protocol DataServiceProtocol: AnyObject {
    func fetchForecast(location: String?, completion: @escaping (Result<[Forecast], Error>) -> Void)
}

class WebService: DataServiceProtocol {
    func fetchForecast(location: String?, completion: @escaping (Result<[Forecast], Error>) -> Void) {
        guard let location = location, let url = buildQueryURL(location: location) else { return }

        URLSession.shared.dataTask(with: url) { (dataOrNil, responseOrNil, errorOrNil) in
            if let error = errorOrNil {
                completion(.failure(error))
                return
            }

            guard let data = dataOrNil else { return }

            do {
                let forecast = try JSONDecoder().decode(ForecastList.self, from: data)
                completion(.success(forecast.list))
            } catch {
                completion(.failure(error))
            }

        }.resume()
    }

    private func buildQueryURL(location: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/forecast"

        components.queryItems = []
        components.queryItems?.append(URLQueryItem(name: "q", value: location))
        components.queryItems?.append(URLQueryItem(name: "appid", value: "c6e381d8c7ff98f0fee43775817cf6ad"))
        components.queryItems?.append(URLQueryItem(name: "units", value: "metric"))

        return components.url
    }
}
