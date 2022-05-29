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
}

class GDCarListHandler: GDListHandler {
    let decoder: GDDataDecoder
    private var carList: GDPoiData?
    
    func list() -> GDPoiData? {
        return carList
    }
    
    func getItem(byIndex index: Int) -> GDPoi? {
        guard let list = self.carList, list.poiList.count > index else { return nil }
        return list.poiList[index]
    }
    
    init(decoder: GDDataDecoder) {
        self.decoder = decoder
    }
    
    func listFromData(_ data: Data) {
        let list = self.decoder.decode(data: data, classType: GDPoiData.self)
        self.carList = list
    }
}
