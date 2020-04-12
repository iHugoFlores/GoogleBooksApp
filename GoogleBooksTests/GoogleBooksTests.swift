//
//  GoogleBooksTests.swift
//  GoogleBooksTests
//
//  Created by Hugo Flores Perez on 4/12/20.
//  Copyright © 2020 Hugo Flores Perez. All rights reserved.
//

@testable import GoogleBooks
import XCTest

class GoogleBooksTests: XCTestCase {

    var resData: VolumesQueryResponse?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAPIDataFetch() throws {
        let completedExpectation = expectation(description: "Downloaded")
        GoogleBooksAPI.getNextPageWithQuery(query: "f", page: 0) { data, _ in
            self.resData = data
            completedExpectation.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssertNotNil(resData, "Error while downloading the data")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
