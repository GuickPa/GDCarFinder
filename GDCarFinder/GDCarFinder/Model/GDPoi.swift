//
//  GDPoi.swift
//  GDCarFinder
//
//  Created by Guglielmo Deletis on 25/05/22.
//

import Foundation

struct GDCoordinate: Codable {
    var latitude: Double
    var longitude: Double
}

struct GDPoi: Codable {
    var id: Int
    var state: String
    var type: String
    var heading: Double
    var coordinate: GDCoordinate
}

struct GDPoiData: Codable {
    var poiList: [GDPoi]
}
