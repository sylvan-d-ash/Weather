//
//  DailyForecastsTableCell.swift
//  Weather App II
//
//  Created by Sylvan Ash on 09/08/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import UIKit

class DailyForecastsTableCell: UITableViewCell {
    private var collectionView: UICollectionView!
    private var forecasts: [Forecast] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func load(content: [Forecast]) {
        forecasts = content
        collectionView.reloadData()
    }
}

private extension DailyForecastsTableCell {
    enum Dimensions {
        static let spacing: CGFloat = 10
    }

    func setupSubviews() {
        selectionStyle = .none

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 160)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(ForecastCollectionCell.self, forCellWithReuseIdentifier: "\(ForecastCollectionCell.self)")
        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Dimensions.spacing),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Dimensions.spacing),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Dimensions.spacing),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Dimensions.spacing),
        ])
    }
}

extension DailyForecastsTableCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecasts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ForecastCollectionCell.self)", for: indexPath) as? ForecastCollectionCell else {
            return UICollectionViewCell()
        }
        cell.load(content: forecasts[indexPath.row])
        return cell
    }
}
