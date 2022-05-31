//
//  GDPoiTableCellView.swift
//  GDCarFinder
//
//  Created by Guglielmo Deletis on 27/05/22.
//

import UIKit
import MapKit
import Foundation

class GDPoiTableViewCell: UITableViewCell {
    static let reuseIdentifier:String = "poi.cell.gd.it"
    private var geocodeOperation: GDGeocodeOperation!
    
    @IBOutlet weak var containerPicView:UIView!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var conditionLabel:UILabel!
    @IBOutlet weak var positionLabel:UILabel!
    @IBOutlet weak var iconView:UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.geocodeOperation?.cancel()
        self.nameLabel.text = nil
        self.conditionLabel.text = nil
        self.positionLabel.text = nil
    }
    
    func loadAddress(coordinate: GDCoordinate, handler: GDOperationQueueHandler) {
        self.geocodeOperation = GDGeocodeOperation(withCoordinate: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude), delegate: self)
        handler.addToQueue(self.geocodeOperation)
    }
}

extension GDPoiTableViewCell: GDGeocodeOperationDelegate {
    func operationStarted(_ operation: GDGeocodeOperation) {
    }
    
    func operationCompleted(_ operation: GDGeocodeOperation, withPlacemarks placemarks: [CLPlacemark]) {
        if placemarks.count > 0 {
            DispatchQueue.main.async {
                let p = placemarks[0]
                self.positionLabel.text = p.name ?? p.locality
            }
        }
    }
    
    func operationFailed(_ operation: GDGeocodeOperation, withError error: Error?) {
        
    }
    
    func operationCancelled(_ operation: GDGeocodeOperation) {
        
    }
    
    
}
