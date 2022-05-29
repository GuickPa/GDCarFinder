//
//  GDDataDecoderTests.swift
//  GDCarFinderTests
//
//  Created by Guglielmo Deletis on 27/05/22.
//

import XCTest
@testable import GDCarFinder

class GDDataDecoderTests: XCTestCase {
    
    let items:[GDPoi] = [
        GDPoi(id: 0, state: "active", type: "taxi", heading: 0.0, coordinate: GDCoordinate(latitute: 0.0, longitude: 0.0)),
        GDPoi(id: 1, state: "active", type: "scooter", heading: 0.0, coordinate: GDCoordinate(latitute: 0.0, longitude: 0.0)),
        GDPoi(id: 2, state: "active", type: "bike", heading: 0.0, coordinate: GDCoordinate(latitute: 0.0, longitude: 0.0)),
    ]

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecode() throws {
        let encoder = JSONEncoder()
        let list:GDPoiData = GDPoiData(poiList: items)
        do {
            let data = try encoder.encode(list)
            let decoder = GDGenericDataDecoder()
            let decoded = decoder.decode(data: data, classType: GDPoiData.self)
            XCTAssertNotNil(decoded)
            XCTAssertNotNil(decoded?.poiList)
            XCTAssert(decoded?.poiList.count == 3)
        } catch {
            print(error.localizedDescription)
        }
    }
}
