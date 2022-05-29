//
//  GDPoiAnnotation.swift
//  GDCarFinder
//
//  Created by Guglielmo Deletis on 29/05/22.
//

import Foundation
import MapKit

class GDPoiAnnotation: NSObject, MKAnnotation {
    let name: String?
    let condition: String?
    var coordinate: CLLocationCoordinate2D
    
    init(name:String, condition:String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.condition = condition
        self.coordinate = coordinate
        
        super.init()
    }
}
