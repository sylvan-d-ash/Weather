//
//  MVPPresenter.swift
//  Weather App II
//
//  Created by Sylvan Ash on 16/09/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import Foundation

private enum DataSource {
    case cache, web

    var description: String {
        switch self {
        case .cache: return "Cache"
        case .web: return "Web"
        }
    }
}

protocol PresenterProtocol {
    var numberOfItems: Int { get }
    func viewDidLoad()
    func didTapSourceButton()
    func didSpecifyLocation(_ location: String?)
    func title(for section: Int) -> String?
    func configure(_ cell: DailyForecastsTableCell, forRowAt index: Int)
}

class MVPPresenter: PresenterProtocol {
    weak var view: ViewProtocol?
    private let webService: DataServiceProtocol
    private let cacheService: DataServiceProtocol
    private var dataSource: DataSource? {
        didSet {
            view?.updateSource(title: dataSource?.description ?? "")
        }
    }
    private var forecastsByDay: [[Forecast]] = []
    var numberOfItems: Int { return forecastsByDay.count }

    init(view: ViewProtocol, webService: DataServiceProtocol = WebService(), cacheService: DataServiceProtocol = CacheService()) {
        self.view = view
        self.webService = webService
        self.cacheService = cacheService
    }

    func viewDidLoad() {
        dataSource = .web
    }

    func didTapSourceButton() {
        if dataSource == .web {
            dataSource = .cache
        } else {
            dataSource = .web
        }

        fetchForecasts(location: nil)
    }

    func didSpecifyLocation(_ location: String?) {
        fetchForecasts(location: location, showLoading: true)
    }

    func title(for section: Int) -> String? {
        let forecasts = forecastsByDay[section]
        guard let first = forecasts.first else { print("no header"); return nil }
        return first.time.toString
    }

    func configure(_ cell: DailyForecastsTableCell, forRowAt index: Int) {
        let forecasts = forecastsByDay[index]
        cell.load(content: forecasts)
    }

    func fetchForecasts(location: String?, showLoading: Bool = false) {
        forecastsByDay = []
        view?.reloadView()

        guard let dataSource = dataSource else { return }

        let dataService: DataServiceProtocol
        switch dataSource {
        case .cache:
            dataService = cacheService
        case .web:
            guard let location = location, !location.isEmpty else { return }
            dataService = webService
        }

        if showLoading {
            view?.showLoading()
        }

        dataService.fetchForecast(location: location) { [weak self] result in
            self?.processForecast(result: result)
        }
    }

    func processForecast(result: Result<[Forecast], Error>) {
        view?.hideLoading()

        switch result {
        case .failure(let error):
            view?.showError(message: error.localizedDescription)

        case .success(let allForecasts):
            var date = Date()
            var forecasts: [[Forecast]] = []
            var forecastsForDay: [Forecast] = []
            for forecast in allForecasts {
                if Calendar.current.isDate(forecast.time, inSameDayAs: date) {
                    forecastsForDay.append(forecast)
                } else {
                    if forecastsForDay.count > 0 {
                        forecasts.append(forecastsForDay)
                    }
                    forecastsForDay = [forecast]
                    date = forecast.time
                }
            }
            forecasts.append(forecastsForDay)
            self.forecastsByDay = forecasts

            DispatchQueue.main.async {
                self.view?.reloadView()
            }
        }
    }
}

private extension Date {
    var toString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: self)
    }
}
