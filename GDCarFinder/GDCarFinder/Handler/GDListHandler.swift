//
//  GDListHandler.swift
//  GDCarFinder
//
//  Created by Guglielmo Deletis on 26/05/22.
//

import Foundation
import UIKit

protocol GDListHandler {
    func list() -> GDPoiData?
    func listFromData(_ data: Data)
    func getItem(byIndex index: Int) -> GDPoi?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
}

class GDCarListHandler: GDListHandler {
    let decoder: GDDataDecoder
    let cellHandler: GDTableViewCellHandler
    private var carList: GDPoiData?
    
    func list() -> GDPoiData? {
        return carList
    }
    
    func getItem(byIndex index: Int) -> GDPoi? {
        guard let list = self.carList, list.poiList.count > index else { return nil }
        return list.poiList[index]
    }
    
    init(decoder: GDDataDecoder, cellHandler: GDTableViewCellHandler) {
        self.decoder = decoder
        self.cellHandler = cellHandler
    }
    
    func listFromData(_ data: Data) {
        let list = self.decoder.decode(data: data, classType: GDPoiData.self)
        self.carList = list
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.carList?.poiList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.cellHandler.tableView(tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let poi = self.getItem(byIndex: indexPath.row) {
            self.cellHandler.tableView(tableView, willDisplay: cell, forRowAt: indexPath, withItem: poi)
        }
    }
}
