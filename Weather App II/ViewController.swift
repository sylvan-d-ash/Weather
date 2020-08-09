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
    private var dailyForecasts: [String: [Forecast]] = [:]

    init(webService: WebServiceProtocol = WebService()) {
        self.webService = webService
        super.init(nibName: nil, bundle: nil)
        setupNavbar()
    }

    required init?(coder: NSCoder) {
        webService = WebService()
        super.init(coder: coder)
        setupNavbar()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

private extension ViewController {
    func setupNavbar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Location", style: .plain, target: self, action: #selector(chooseLocation))
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

        case .success(let forecasts):
            var date = Date()
            var dailyForecasts: [String: [Forecast]] = [:]
            var dayForecast: [Forecast] = []
            for forecast in forecasts {
                if Calendar.current.isDate(forecast.time, inSameDayAs: date) {
                    dayForecast.append(forecast)
                } else {
                    dailyForecasts[date.toString] = dayForecast
                    dayForecast = [forecast]
                    date = forecast.time
                }
            }
            dailyForecasts[date.toString] = dayForecast
            self.dailyForecasts = dailyForecasts
            self.tableView.reloadData()
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
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
}
