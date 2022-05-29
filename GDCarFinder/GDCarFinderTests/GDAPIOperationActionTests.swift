//
//  GDAPIOperationActionTests.swift
//  RickAndMortyAPITests
//
//  Created by Guglielmo Deletis on 20/04/22.
//

import XCTest
@testable import GDCarFinder

class TestSessionHandler: GDSessionHandler {
    private var session: URLSession
    
    init() {
        self.session = URLSession(configuration: .default)
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.session.dataTask(with: request, completionHandler: completionHandler)
    }
    
    func endDataTask() {
        
    }
}

class GDAPIOperationActionTests: XCTestCase {
    var sessionHandler:TestSessionHandler?
    
    override func setUp() {
        self.sessionHandler = TestSessionHandler()
    }

    override func tearDown() {
        self.sessionHandler = nil
    }
    
    func testGet() throws {
        let expectation = XCTestExpectation(description: "Get Request")
        let operation = try GDAPIOperationAction(GDConst.baseURLString, method: .get)
        operation.main(sessionHandler: self.sessionHandler!) { data, error, cancelled in
            XCTAssert(data != nil)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
}
