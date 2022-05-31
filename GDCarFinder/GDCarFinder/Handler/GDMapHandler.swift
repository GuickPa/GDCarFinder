//
//  GDMapHandler.swift
//  GDCarFinder
//
//  Created by Guglielmo Deletis on 29/05/22.
//

import Foundation
import UIKit
import MapKit

struct GDMapRect {
    let p1: CLLocationCoordinate2D
    let p2: CLLocationCoordinate2D
}

protocol GDMapHandler: AnyObject {
    func list() -> GDPoiData?
    func listFromData(_ data: Data)
    func getItem(byIndex index: Int) -> GDPoi?
    func viewDidLoad(view: MKMapView)
    func mapView(didFinishLoadingMap mapView: MKMapView)
    func mapView(regionDidChange mapView: MKMapView) -> GDMapRect
    func loadAnnotations(inMapView mapView: MKMapView)
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView)
}

class GDMapViewHandler: GDMapHandler {
    let listHandler: GDListHandler
    private var geocodeOperation: GDGeocodeOperation!
    weak var lastSelectedAnnotation: MKAnnotationView? = nil
    
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
    
    private func getRegion(p1: CLLocationCoordinate2D, p2: CLLocationCoordinate2D) -> MKCoordinateRegion {
        var minLat:CLLocationDegrees
        var maxLat:CLLocationDegrees
        var minLon:CLLocationDegrees
        var maxLon:CLLocationDegrees
        
        if p1.latitude > p2.latitude {
            minLat = p2.latitude
            maxLat = p1.latitude
        } else {
            minLat = p1.latitude
            maxLat = p2.latitude
        }
        
        if p1.longitude > p2.longitude {
            minLon = p2.longitude
            maxLon = p1.longitude
        } else {
            minLon = p1.longitude
            maxLon = p2.longitude
        }
        
        let span = MKCoordinateSpan(latitudeDelta: maxLat - minLat, longitudeDelta: maxLon - minLon)
            
        let center = CLLocationCoordinate2DMake((maxLat - span.latitudeDelta / 2), maxLon - span.longitudeDelta / 2);
        
        return MKCoordinateRegion(center: center, span: span)
    }
    
    func viewDidLoad(view: MKMapView) {
        view.setRegion(self.getRegion(
            p1: GDConst.regionP1Coordinate,
            p2: GDConst.regionP2Coordinate
        ), animated: false)
    }
    
    func mapView(didFinishLoadingMap mapView: MKMapView) {
        
    }
    
    func mapView(regionDidChange mapView: MKMapView) -> GDMapRect {
        let region = mapView.region
        let p1 = CLLocationCoordinate2D(
            latitude: region.center.latitude - region.span.latitudeDelta/2, longitude: region.center.longitude - region.span.longitudeDelta/2)
        let p2 = CLLocationCoordinate2D(
            latitude: region.center.latitude + region.span.latitudeDelta/2, longitude: region.center.longitude + region.span.longitudeDelta/2)
        
        return GDMapRect(p1: p1, p2: p2)
    }
    
    func loadAnnotations(inMapView mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations)
        self.list()?.poiList.forEach({ item in
            let annotation = GDPoiAnnotation(
                name: "\(item.type) ID \(item.id)",
                condition: item.state,
                coordinate: CLLocationCoordinate2D(latitude: item.coordinate.latitude, longitude: item.coordinate.longitude))
            mapView.addAnnotation(annotation)
        })
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        let annotationIdentifier = GDPoiAnnotation.identifier
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        }
        if let annotationView = annotationView {
            annotationView.rightCalloutAccessoryView = nil
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "vehicle")
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? GDPoiAnnotation {
            self.lastSelectedAnnotation = view
            self.loadAddress(coordinate: annotation.coordinate, handler: GDOperationQueueManager.instance)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view == self.lastSelectedAnnotation {
            self.lastSelectedAnnotation = nil
        }
    }
}

extension GDMapViewHandler: GDGeocodeOperationDelegate {
    func operationStarted(_ operation: GDGeocodeOperation) {
        
    }
    
    func operationCompleted(_ operation: GDGeocodeOperation, withPlacemarks placemarks: [CLPlacemark]) {
        if placemarks.count > 0 {
            let p = placemarks[0]
            (self.lastSelectedAnnotation?.annotation as? GDPoiAnnotation)?.address = p.name ?? p.locality
            // Tricky way to update information
            self.lastSelectedAnnotation?.annotation = self.lastSelectedAnnotation?.annotation
        }
    }
    
    func operationFailed(_ operation: GDGeocodeOperation, withError error: Error?) {
        
    }
    
    func operationCancelled(_ operation: GDGeocodeOperation) {
        
    }
    
    func loadAddress(coordinate: CLLocationCoordinate2D, handler: GDOperationQueueHandler) {
        if self.geocodeOperation != nil {
            self.geocodeOperation.cancel()
        }
        self.geocodeOperation = GDGeocodeOperation(withCoordinate: coordinate, delegate: self)
        handler.addToQueue(self.geocodeOperation)
    }
}
