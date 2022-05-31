//
//  GDCacheTest.swift
//  
//
//  Created by Guglielmo Deletis on 04/05/22.
//

import XCTest
@testable import GDCarFinder

class GDCacheTest: XCTestCase {
    
    var cache: GDCache!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCache() throws {
        cache = GDCache.instance
        cache.setValue("test0", value: "test0")
        cache.setValue("test1", value: "test1")
        cache.setValue("test2", value: "test2")
        cache.setValue("test3", value: "test3")
        
        XCTAssert(cache.getValue("test0") as? String == "test0")
        XCTAssert(cache.getValue("test1") as? String == "test1")
        XCTAssert(cache.getValue("test2") as? String == "test2")
        XCTAssert(cache.getValue("test3") as? String == "test3")
    }
}
