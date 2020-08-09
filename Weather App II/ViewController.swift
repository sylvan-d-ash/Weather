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
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let forecasts):
                print(forecasts)
            }
        }
    }
}
