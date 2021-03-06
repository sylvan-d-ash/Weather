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
        XCTAssertTrue(view.didCallUpdateSource)
        XCTAssert(view.sourceButtonTitle == "Web") // TODO: make the DataSource accessible so we can use the 'description' value instead of hard coding the values here
    }

    func testDidTapSourceButtonUpdatesTitle() {
        sut.didTapSourceButton()
        XCTAssertTrue(view.didCallUpdateSource)
        XCTAssert(view.sourceButtonTitle == "Web")

        sut.didTapSourceButton()
        XCTAssert(view.sourceButtonTitle == "Cache")
    }

    func testDidTapSourceButtonUpdatesDataDisplayed() {
        sut.didTapSourceButton()
        XCTAssertFalse(webService.didCallFetchForecast)
        XCTAssertFalse(cacheService.didCallFetchForecast)

        sut.didTapSourceButton()
        XCTAssertFalse(webService.didCallFetchForecast)
        XCTAssertTrue(cacheService.didCallFetchForecast)
        XCTAssertNil(cacheService.location)
    }

    func testCacheServiceSucceeded() {
        cacheService.didSucceed = true
        sut.viewDidLoad()
        sut.didTapSourceButton()

        XCTAssertFalse(webService.didCallFetchForecast)
        XCTAssertTrue(cacheService.didCallFetchForecast)
        XCTAssertNil(cacheService.location)
        XCTAssert(sut.numberOfItems > 0)

        XCTAssertTrue(view.didCallReloadView)
        XCTAssertFalse(view.didCallShowLoading)
    }

    func testCacheServiceFailed() {
        cacheService.didSucceed = false
        sut.viewDidLoad()
        sut.didTapSourceButton()

        XCTAssertFalse(webService.didCallFetchForecast)
        XCTAssertTrue(cacheService.didCallFetchForecast)
        XCTAssertNil(cacheService.location)
        XCTAssert(sut.numberOfItems == 0)

        XCTAssertTrue(view.didCallShowError)
        XCTAssertNotNil(view.errorMessage)
    }

    func testLocationSpecifiedWithNoDataSource() {
        sut.didSpecifyLocation("London")
        XCTAssertFalse(webService.didCallFetchForecast)
        XCTAssertFalse(cacheService.didCallFetchForecast)
    }

    func testNoLocationSpecifiedWithWebDataSource() {
        webService.didSucceed = true
        sut.viewDidLoad()
        sut.didSpecifyLocation(nil)

        XCTAssert(sut.numberOfItems == 0)
        XCTAssertFalse(webService.didCallFetchForecast)
    }

    func testWebServiceSucceeded() {
        webService.didSucceed = true
        sut.viewDidLoad()
        sut.didSpecifyLocation("London")

        XCTAssertFalse(cacheService.didCallFetchForecast)
        XCTAssertTrue(webService.didCallFetchForecast)
        XCTAssert(webService.location == "London")
        XCTAssert(sut.numberOfItems > 0)

        XCTAssertTrue(view.didCallShowLoading)
        XCTAssertTrue(view.didCallHideLoading)
        XCTAssertTrue(view.didCallReloadView)
    }

    func testWebServiceFailed() {
        webService.didSucceed = false
        sut.viewDidLoad()
        sut.didSpecifyLocation("London")

        XCTAssertFalse(cacheService.didCallFetchForecast)
        XCTAssertTrue(webService.didCallFetchForecast)
        XCTAssert(webService.location == "London")
        XCTAssert(sut.numberOfItems == 0)

        XCTAssertTrue(view.didCallShowLoading)
        XCTAssertTrue(view.didCallHideLoading)
        XCTAssertTrue(view.didCallShowError)
        XCTAssertNotNil(view.errorMessage)
    }
}
