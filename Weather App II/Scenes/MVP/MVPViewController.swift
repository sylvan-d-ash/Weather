//
//  MVPViewController.swift
//  Weather App II
//
//  Created by Sylvan Ash on 16/09/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import UIKit

protocol ViewProtocol: AnyObject {
    //
}

class MVPViewController: UITableViewController {
    private var sourceButton: UIBarButtonItem!

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
            //self?.didSpecifyLocation(alertController.textFields?[0].text)
        }
        alertController.addAction(addCityAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    @objc func toggleSource() {
//        if dataSource == .web {
//            dataSource = .cache
//        } else {
//            dataSource = .web
//        }

//        sourceButton.title = "Source: \(dataSource.description)"
        //fetchForecasts(location: nil)
    }
}

extension MVPViewController: ViewProtocol {
    //
}
