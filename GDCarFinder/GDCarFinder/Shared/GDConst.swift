//
//  GDConst.swift
//  
//
//  Created by Guglielmo Deletis on 20/04/22.
//

import Foundation
import UIKit
import CoreLocation

class GDConst {
    static let baseURLString = "https://poi-api.mytaxi.com"
    static let vehicleListBaseURLString = "\(GDConst.baseURLString)/PoiService/poi/v1"
    static let defaultVehicleListURLString = "\(GDConst.vehicleListBaseURLString)?p2Lat=53.394655&p1Lon=9.757589&p1Lat=53.694865&p2Lon=10.099891"
    
    // colors
    static let defaultBackgroundColor = UIColor(hexString: "3C3E44")
    static let cellBGColor0 = UIColor(hexString: "FEFEFE")
    static let cellBGColor1 = UIColor(hexString: "FAFAFA")
    
    // constants
    static let centerCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 53.5532674, longitude: 9.9907421) // Hamburg center from Google Maps
    static let regionP1Coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 53.694865, longitude: 9.757589)
    static let regionP2Coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 53.394655, longitude: 10.099891)
    
    // generic messages
    static let messageUnknown = GDConst.localizedString("gd_message_unknown")
    
    static func localizedString (_ title: String) -> String {
      return NSLocalizedString(title, comment: "")
    }
}
