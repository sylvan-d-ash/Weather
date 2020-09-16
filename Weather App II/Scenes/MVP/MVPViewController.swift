//
//  MVPViewController.swift
//  Weather App II
//
//  Created by Sylvan Ash on 16/09/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import UIKit

protocol ViewProtocol: AnyObject {
    func reloadView()
    func showError(message: String)
    func updateSource(title: String)
}

class MVPViewController: UITableViewController {
    private var sourceButton: UIBarButtonItem!
    var presenter: PresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.numberOfItems ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter?.title(for: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(DailyForecastsTableCell.self)", for: indexPath) as? DailyForecastsTableCell else {
            return UITableViewCell()
        }
        presenter?.configure(cell, forRowAt: indexPath.row)
        return cell
    }
}

private extension MVPViewController {
    func setupSubviews() {
        sourceButton = UIBarButtonItem(title: "Source: Web", style: .plain, target: self, action: #selector(toggleSource))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Location", style: .plain, target: self, action: #selector(chooseLocation)),
            sourceButton
        ]

        tableView.rowHeight = 110
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView()
        tableView.register(DailyForecastsTableCell.self, forCellReuseIdentifier: "\(DailyForecastsTableCell.self)")
    }

    @objc func chooseLocation() {
        let alertController = UIAlertController(title: "Enter city", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)

        let addCityAction = UIAlertAction(title: "Done", style: .default) { [weak self] _ in
            self?.presenter?.didSpecifyLocation(alertController.textFields?[0].text)
        }
        alertController.addAction(addCityAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    @objc func toggleSource() {
        presenter?.didTapSourceButton()
    }
}

extension MVPViewController: ViewProtocol {
    func reloadView() {
        tableView.reloadData()
    }

    func showError(message: String) {
        let controller = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(controller, animated: true, completion: nil)
    }

    func updateSource(title: String) {
        sourceButton.title = "Source: \(title)"
    }
}
