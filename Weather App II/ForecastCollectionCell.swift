//
//  ForecastCollectionCell.swift
//  Weather App II
//
//  Created by Sylvan Ash on 09/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import UIKit

class ForecastCollectionCell: UICollectionViewCell {
    private let timeLabel = UILabel()
    private let iconImageView = UIImageView()
    private let tempLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func load(content: Forecast) {
        timeLabel.text = content.time.toString
        tempLabel.text = "\(content.temp)°"
    }
}

private extension ForecastCollectionCell {
    func setupSubviews() {
        let stackview = UIStackView(arrangedSubviews: [timeLabel, iconImageView, tempLabel])
        stackview.axis = .vertical
        stackview.spacing = 10
        contentView.addSubview(stackview)
        stackview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackview.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
