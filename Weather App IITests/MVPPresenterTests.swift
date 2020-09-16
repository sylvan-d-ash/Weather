//
//  MVPPresenterTests.swift
//  Weather App IITests
//
//  Created by Sylvan Ash on 16/09/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import XCTest
@testable import Weather_App_II

class ViewSpy: ViewProtocol {
    private(set) var didCallReloadView = false
    private(set) var didCallShowError = false
    private(set) var didCallUpdateSource = false
    private(set) var didCallShowLoading = false
    private(set) var didCallHideLoading = false
    private(set) var errorMessage: String?
    private(set) var sourceButtonTitle: String?

    func reloadView() {
        didCallReloadView = true
    }

    func showError(message: String) {
        didCallShowError = true
        errorMessage = message
    }

    func updateSource(title: String) {
        didCallUpdateSource = true
        sourceButtonTitle = title
    }

    func showLoading() {
        didCallShowLoading = true
    }

    func hideLoading() {
        didCallHideLoading = true
    }
}

class MVPPresenterTests: XCTestCase {
    var sut: MVPPresenter!

    override func setUpWithError() throws {
        //
    }

    override func tearDownWithError() throws {
        //
    }

    func testViewDidLoadUpdatesSourceButtonTitle() {
        //
    }

    func testDidTapSourceButtonUpdatesTitle() {
        //
    }

    func testDidTapSourceButtonUpdatesDataDisplayed() {
        //
    }
}
