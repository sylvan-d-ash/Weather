//
//  ViewController.swift
//  Weather App II
//
//  Created by Sylvan Ash on 09/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    private let webService: WebServiceProtocol
    private var location: String?
    private var forecastsByDay: [[Forecast]] = []

    init(webService: WebServiceProtocol = WebService()) {
        self.webService = webService
        super.init(nibName: nil, bundle: nil)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return forecastsByDay.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let forecasts = forecastsByDay[section]
        guard let first = forecasts.first else { print("no header"); return nil }
        return first.time.toString
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(DailyForecastsTableCell.self)", for: indexPath) as? DailyForecastsTableCell else {
            return UITableViewCell()
        }

        let forecasts = forecastsByDay[indexPath.section]
        cell.load(content: forecasts)

        return cell
    }
}

private extension ViewController {
    func setupSubviews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Location", style: .plain, target: self, action: #selector(chooseLocation))

        tableView.rowHeight = 110
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView()
        tableView.register(DailyForecastsTableCell.self, forCellReuseIdentifier: "\(DailyForecastsTableCell.self)")
    }

    @objc func chooseLocation() {
        let alertController = UIAlertController(title: "Enter city", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)

        let addCityAction = UIAlertAction(title: "Done", style: .default) { [weak self] _ in
            self?.didSpecifyLocation(alertController.textFields?[0].text)
        }
        alertController.addAction(addCityAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    func didSpecifyLocation(_ location: String?) {
        guard let location = location else { return }
        self.location = location

        webService.fetchForecast(location: location) { [weak self] result in
            self?.processForecast(result: result)
        }
    }

    func processForecast(result: Result<[Forecast], Error>) {
        switch result {
        case .failure(let error):
            showError(message: error.localizedDescription)

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
                self.tableView.reloadData()
            }
        }
    }

    func showError(message: String) {
        let controller = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(controller, animated: true, completion: nil)
    }
}

private extension Date {
    var toString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: self)
    }
}
