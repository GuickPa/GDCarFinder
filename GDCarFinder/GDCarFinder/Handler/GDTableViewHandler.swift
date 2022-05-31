//
//  GDTableViewHandler.swift
//  GDCarFinder
//
//  Created by Guglielmo Deletis on 30/05/22.
//

import Foundation
import UIKit

protocol GDTableViewHandler {
    func list() -> GDPoiData?
    func listFromData(_ data: Data)
    func getItem(byIndex index: Int) -> GDPoi?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    func tableViewDidEndDecelerating(_ tableView: UITableView)
}

class GDCarTableViewHandler: GDTableViewHandler {
    let listHandler: GDListHandler
    let cellHandler: GDTableViewCellHandler
    
    func list() -> GDPoiData? {
        return listHandler.list()
    }
    
    func getItem(byIndex index: Int) -> GDPoi? {
        return listHandler.getItem(byIndex: index)
    }
    
    init(listHandler: GDListHandler, cellHandler: GDTableViewCellHandler) {
        self.listHandler = listHandler
        self.cellHandler = cellHandler
    }
    
    func listFromData(_ data: Data) {
        return listHandler.listFromData(data)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listHandler.list()?.poiList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.cellHandler.tableView(tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let poi = self.getItem(byIndex: indexPath.row) {
            self.cellHandler.tableView(tableView, willDisplay: cell, forRowAt: indexPath, withItem: poi)
        }
    }
    
    func tableViewDidEndDecelerating(_ tableView: UITableView) {
        if let visibles = tableView.indexPathsForVisibleRows {
            visibles.forEach { indexPath in
                if let c = tableView.cellForRow(at: indexPath) as? GDPoiTableViewCell, let poi = self.getItem(byIndex: indexPath.row) {
                    // turn coordinate into address
                    c.loadAddress(coordinate: poi.coordinate, handler: GDOperationQueueManager.instance)
                }
            }
        }
    }
}

