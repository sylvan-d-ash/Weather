//
//  Webservice.swift
//  Weather App II
//
//  Created by Sylvan Ash on 09/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import Foundation

protocol WebServiceProtocol: AnyObject {
    func fetchForecast(location: String, completion: @escaping (Result<Any, Error>) -> Void)
}

class WebService: WebServiceProtocol {
    func fetchForecast(location: String, completion: @escaping (Result<Any, Error>) -> Void) {
        guard let url = buildQueryURL(location: location) else { return }
        print(url.absoluteString)

        URLSession.shared.dataTask(with: url) { (dataOrNil, responseOrNil, errorOrNil) in
            if let error = errorOrNil {
                completion(.failure(error))
                return
            }
            guard let data = dataOrNil else { return }

            // TODO: parse data

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
