//
//  GDListHandlerTests.swift
//  GDCarFinderTests
//
//  Created by Guglielmo Deletis on 27/05/22.
//

import XCTest
@testable import GDCarFinder

class GDListHandlerTests: XCTestCase {
    
    let decoder:GDDataDecoder = GDGenericDataDecoder()
    let items:[GDPoi] = [
        GDPoi(id: 0, state: "active", type: "taxi", heading: 0.0, coordinate: GDCoordinate(latitude: 0.0, longitude: 0.0)),
        GDPoi(id: 1, state: "active", type: "scooter", heading: 0.0, coordinate: GDCoordinate(latitude: 0.0, longitude: 0.0)),
        GDPoi(id: 2, state: "active", type: "bike", heading: 0.0, coordinate: GDCoordinate(latitude: 0.0, longitude: 0.0)),
    ]
    let cellHandler:GDTableViewCellHandler = GDPoiTableViewCellHandler()
    
    class TestListHandler: GDListHandler {
        let data: GDPoiData
        
        init(data: GDPoiData) {
            self.data = data
        }
        
        func list() -> GDPoiData? {
            return data
        }
        
        func listFromData(_ data: Data) {
            
        }
        
        func getItem(byIndex index: Int) -> GDPoi? {
            if index < data.poiList.count {
                return data.poiList[index]
            }
            return nil
        }
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testListHandler() throws {
        let encoder = JSONEncoder()
        let poiData:GDPoiData = GDPoiData(poiList: items)
        do {
            // prepare data
            let data = try encoder.encode(poiData)
            
            let listHandler = GDCarTableViewHandler(listHandler: TestListHandler(data:poiData), cellHandler: GDPoiTableViewCellHandler())
            listHandler.listFromData(data)
            let list = listHandler.list()
            XCTAssertNotNil(list)
            XCTAssert(list?.poiList.count == 3)
            
            let item = listHandler.getItem(byIndex: 0)
            XCTAssert(item?.id == items[0].id)
            
            let outOfIndexItem = listHandler.getItem(byIndex: items.count)
            XCTAssertNil(outOfIndexItem)
        } catch {
            print(error.localizedDescription)
        }
    }
}
