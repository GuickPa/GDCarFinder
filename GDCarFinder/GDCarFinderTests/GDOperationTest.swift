//
//  GDOperationTest.swift
//  RickAndMortyAPITests
//
//  Created by Guglielmo Deletis on 20/04/22.
//

import XCTest
@testable import GDCarFinder

class TestOperationAction: GDOperationAction {
    func main(sessionHandler: GDSessionHandler, callback: @escaping GDOperationActionCallback) {
        let data = "TEST OK".data(using: .utf8)
        callback(data, nil, false)
    }
    
    func cancel() {
        
    }
}

class TestOperationErrorAction: GDOperationAction {
    func main(sessionHandler: GDSessionHandler, callback: @escaping GDOperationActionCallback) {
        callback(nil, GDError.instanceError, false)
    }
    
    func cancel() {
        
    }
}

class GDOperationTest: XCTestCase, GDOperationDelegate {
    var startedExpectation:XCTestExpectation!
    var completedExpectation:XCTestExpectation!
    var failedExpectation:XCTestExpectation!
    
    func testOKResponse() throws {
        self.startedExpectation = XCTestExpectation(description: "started")
        self.completedExpectation = XCTestExpectation(description: "completed")
        let operation = GDOperation(withAction: TestOperationAction(), delegate: self)
        let queue = OperationQueue()
        queue.addOperation(operation)
        wait(for: [self.startedExpectation, self.completedExpectation], timeout: 10)
    }
    
    func testErrorResponse() throws {
        self.startedExpectation = XCTestExpectation(description: "started")
        self.failedExpectation = XCTestExpectation(description: "failed")
        let operation = GDOperation(withAction: TestOperationErrorAction(), delegate: self)
        let queue = OperationQueue()
        queue.addOperation(operation)
        wait(for: [self.startedExpectation, self.failedExpectation], timeout: 10)
    }
    
    //MARK: delegate
    func operationStarted(_ operation: GDOperation) {
        self.startedExpectation.fulfill()
    }
    
    func operationCompleted(_ operation: GDOperation, withData data: Data?) {
        self.completedExpectation.fulfill()
    }
    
    func operationFailed(_ operation: GDOperation, withError error: Error?) {
        self.failedExpectation.fulfill()
    }
    
    func operationCancelled(_ operation: GDOperation) {
        // do nothing
    }
}
