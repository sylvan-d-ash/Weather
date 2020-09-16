//
//  MVPPresenterTests.swift
//  Weather App IITests
//
//  Created by Sylvan Ash on 16/09/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import XCTest
@testable import Weather_App_II

class MVPPresenterTests: XCTestCase {
    var sut: MVPPresenter!
    var view: ViewSpy!
    var webService: WebServiceMock!
    var cacheService: CacheServiceMock!

    override func setUpWithError() throws {
        view = ViewSpy()
        webService = WebServiceMock()
        cacheService = CacheServiceMock()
        sut = MVPPresenter(view: view, webService: webService, cacheService: cacheService)
    }

    override func tearDownWithError() throws {
        view = nil
        webService = nil
        cacheService = nil
        sut = nil
    }

    func testViewDidLoadUpdatesSourceButtonTitle() {
        sut.viewDidLoad()
        XCTAssert(view.didCallUpdateSource)
        XCTAssert(view.sourceButtonTitle == "Web") // TODO: make the DataSource accessible so we can use the 'description' value instead of hard coding the values here
    }

    func testDidTapSourceButtonUpdatesTitle() {
        sut.didTapSourceButton()
        XCTAssert(view.didCallUpdateSource)
        XCTAssert(view.sourceButtonTitle == "Web")

        sut.didTapSourceButton()
        XCTAssert(view.sourceButtonTitle == "Cache")
    }

    func testDidTapSourceButtonUpdatesDataDisplayed() {
        //
    }
}
