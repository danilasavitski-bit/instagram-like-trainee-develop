//
//  Instagram_like_traineeUITests.swift
//  Instagram-like-traineeUITests
//
//  Created by  on 26.11.25.
//

import XCTest

final class Instagram_like_traineeUITests: XCTestCase {
 
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        let app = XCUIApplication()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        app = nil
    }

    @MainActor
    func testCollectionViewExists() throws {
        // GIVEN
        app.launch()
        // THEN
       XCTAssert(app.collectionViews["homePageCollectionView"].exists)
    }
    
    func testMovedToDirect() throws {
        // Given
        app.launch()
        // WHEN
        app.buttons["buttonToDirectMessages"].tap()
        // THEN
        XCTAssert( app.collectionViews["DirectPageCollectionView"].exists)
    }
    
    func testMovedToDialog() throws {
        // GIVEN
        app.launch()
        // WHEN
        app.buttons["buttonToDirectMessages"].tap()
        app.collectionViews["DirectPageCollectionView"].cells["section_1_item_0"].tap()
        // THEN
        XCTAssert(app.otherElements["dialogScreenView"].exists)
    }
    
    

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
