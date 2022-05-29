//
//  GDMapHandler.swift
//  GDCarFinder
//
//  Created by Guglielmo Deletis on 29/05/22.
//

import Foundation
import UIKit
import MapKit

protocol GDMapHandler: AnyObject {
    func list() -> GDPoiData?
    func listFromData(_ data: Data)
    func getItem(byIndex index: Int) -> GDPoi?
    func viewDidLoad(view: MKMapView)
    func mapView(didFinishLoadingMap mapView: MKMapView)
    func mapView(regionDidChange mapView: MKMapView)
    func loadAnnotations(inMapView mapView: MKMapView)
}

class GDMapViewHandler: GDMapHandler {
    let listHandler: GDListHandler
    
    func list() -> GDPoiData? {
        return listHandler.list()
    }
    
    func getItem(byIndex index: Int) -> GDPoi? {
        return listHandler.getItem(byIndex: index)
    }
    
    init(listHandler: GDListHandler) {
        self.listHandler = listHandler
    }
    
    func listFromData(_ data: Data) {
        return listHandler.listFromData(data)
    }
    
    private func getRegion() -> MKCoordinateRegion {
        var minLat:CLLocationDegrees
        var maxLat:CLLocationDegrees
        var minLon:CLLocationDegrees
        var maxLon:CLLocationDegrees
        
        if GDConst.regionP1Coordinate.latitude > GDConst.regionP2Coordinate.latitude {
            minLat = GDConst.regionP2Coordinate.latitude
            maxLat = GDConst.regionP1Coordinate.latitude
        } else {
            minLat = GDConst.regionP1Coordinate.latitude
            maxLat = GDConst.regionP2Coordinate.latitude
        }
        
        if GDConst.regionP1Coordinate.longitude > GDConst.regionP2Coordinate.longitude {
            minLon = GDConst.regionP2Coordinate.longitude
            maxLon = GDConst.regionP1Coordinate.longitude
        } else {
            minLon = GDConst.regionP1Coordinate.longitude
            maxLon = GDConst.regionP2Coordinate.longitude
        }
        
        let span = MKCoordinateSpan(latitudeDelta: maxLat - minLat, longitudeDelta: maxLon - minLon)
            
        let center = CLLocationCoordinate2DMake((maxLat - span.latitudeDelta / 2), maxLon - span.longitudeDelta / 2);
        
        return MKCoordinateRegion(center: center, span: span)
    }
    
    func viewDidLoad(view: MKMapView) {
        view.setRegion(self.getRegion(), animated: false)
    }
    
    func mapView(didFinishLoadingMap mapView: MKMapView) {
        
    }
    
    func mapView(regionDidChange mapView: MKMapView) {
        
    }
    
    func loadAnnotations(inMapView mapView: MKMapView) {
        self.list()?.poiList.forEach({ item in
            let annotation = GDPoiAnnotation(
                name: "\(item.type) ID \(item.id)",
                condition: item.state,
                coordinate: CLLocationCoordinate2D(latitude: item.coordinate.latitude, longitude: item.coordinate.longitude))
            mapView.addAnnotation(annotation)
        })
    }
}
