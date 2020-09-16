//
//  StartViewController.swift
//  Weather App II
//
//  Created by Sylvan Ash on 16/09/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }

    private func setupSubviews() {
        view.backgroundColor = .white

        let mvcButton = UIButton(type: .system)
        mvcButton.setTitle("MVC Setup", for: .normal)
        mvcButton.addTarget(self, action: #selector(openMVCScene), for: .touchUpInside)

        let mvpButton = UIButton(type: .system)
        mvpButton.setTitle("MVP Setup", for: .normal)
        mvpButton.addTarget(self, action: #selector(openMVPScene), for: .touchUpInside)

        [mvcButton, mvpButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            mvcButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mvcButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            mvcButton.heightAnchor.constraint(equalToConstant: 35),
            mvcButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3),

            mvpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mvpButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            mvpButton.heightAnchor.constraint(equalToConstant: 35),
            mvpButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3),
        ])
    }

    @objc private func openMVCScene() {
        let controller = MVCViewController(webService: WebService())
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc private func openMVPScene() {
        let controller = MVPViewController()
        let presenter = MVPPresenter(view: controller)
        controller.presenter = presenter

        navigationController?.pushViewController(controller, animated: true)
    }
}
