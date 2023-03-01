//
//  LoginTest.swift
//  Chatty_SwiftUITests
//
//  Created by Clyde on 2023/03/01.
//

import XCTest

final class LoginTest: XCTestCase {
    func login() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        app.textFields["아이디"].typeText("TestAccount1")
        

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
