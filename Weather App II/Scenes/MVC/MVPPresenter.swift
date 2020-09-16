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
}

class MVPPresenter: PresenterProtocol {
    weak var view: ViewProtocol?
    private let webService: DataServiceProtocol
    private let cacheService: DataServiceProtocol
    private var dataSource: DataSource? {
        didSet {
            // TODO: update view
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
}
