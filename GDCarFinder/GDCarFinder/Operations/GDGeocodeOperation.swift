//
//  GDGeocodeOperation.swift
//  GDCarFinder
//
//  Created by Guglielmo Deletis on 30/05/22.
//

import Foundation
import CoreLocation

protocol GDGeocodeOperationDelegate: AnyObject {
    func operationStarted(_ operation: GDGeocodeOperation)
    func operationCompleted(_ operation: GDGeocodeOperation, withPlacemarks placemarks: [CLPlacemark])
    func operationFailed(_ operation: GDGeocodeOperation, withError error:Error?)
    func operationCancelled(_ operation: GDGeocodeOperation)
}

class GDGeocodeOperation: Operation, GDOperationHandler {
    
    private var _isExecuting:Bool = false
    private var _isFinished:Bool = false
    private var _isCancelled:Bool = false
    private var coordinate: CLLocationCoordinate2D
    
    private weak var delegate:GDGeocodeOperationDelegate?
    
    override var isExecuting: Bool {
        get {
            return _isExecuting
        }
    }
    
    override var isFinished: Bool {
        get {
            return _isFinished
        }
    }
    
    override var isCancelled: Bool {
        get {
            return _isCancelled
        }
        set {
            _isCancelled = newValue
        }
    }
    
    override func start() {
        if self.isCancelled {
            _isExecuting = false
            _isFinished = true
            self.delegate?.operationCancelled(self)
        }
        else {
            _isExecuting = true
            _isFinished = false
            self.main()
        }
    }
    
    override func main() {
        if self.isCancelled {
            self.finish()
            self.delegate?.operationCancelled(self)
        }
        else {
            self.delegate?.operationStarted(self)
            let key = "\(self.coordinate.latitude),\(self.coordinate.longitude)"
            if let placemarks = GDCache.instance.getValue(key) as? [CLPlacemark] {
                self.delegate?.operationCompleted(self, withPlacemarks: placemarks)
                self.finish()
            } else {
                CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)) { placemarks, error in
                    guard let placemark = placemarks, error == nil else {
                        self.delegate?.operationFailed(self, withError: error)
                        self.finish()
                        return
                    }
                    GDCache.instance.setValue(key, value: placemark)
                    self.delegate?.operationCompleted(self, withPlacemarks: placemark)
                    self.finish()
                }
            }
        }
    }
    
    override func cancel() {
        super.cancel()
        self.finish()
    }
    
    func finish() {
        if self.isExecuting {
            self.willChangeValue(forKey: "isExecuting")
            self.willChangeValue(forKey: "isFinished")
            _isExecuting = false
            _isFinished = true
            self.didChangeValue(forKey: "isFinished")
            self.didChangeValue(forKey: "isExecuting")
        }
    }
    
    // MARK: init
    init(withCoordinate coordinate:CLLocationCoordinate2D, delegate: GDGeocodeOperationDelegate?) {
        self.coordinate = coordinate
        self.delegate = delegate
    }
    
}
