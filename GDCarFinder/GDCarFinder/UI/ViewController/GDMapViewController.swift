//
//  GDMapViewController.swift
//  GDCarFinder
//
//  Created by Guglielmo Deletis on 29/05/22.
//

import Foundation
import UIKit
import MapKit

class GDMapViewController: GDBaseViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loadingView: UIView!
    private var mapHandler: GDMapHandler
    
    init(loader:GDLoader, mapHandler: GDMapHandler) {
        self.mapHandler = mapHandler
        super.init(loader: loader, nibName: "GDMapViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapHandler.viewDidLoad(view: self.mapView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loader.delegate = self
        if !self.loader.isLoading {
            if !self.loader.hasFailed {
                self.loadAnnotations()
            } else {
                self.loader.load(urlString: GDConst.defaultVehicleListURLString, handler: GDOperationQueueManager.instance)
            }
        }
    }
    
    private func loadAnnotations() {
        self.mapHandler.loadAnnotations(inMapView: self.mapView)
    }
}

extension GDMapViewController: MKMapViewDelegate {
    //MARK: MKMapViewDelegate
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        self.mapHandler.mapView(regionDidChange: mapView)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        self.mapHandler.mapView(didFinishLoadingMap: mapView)
    }
    
    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        self.mapHandler.mapView(didFinishLoadingMap: mapView)
    }
}

//MARK: GDLoaderDelegate
extension GDMapViewController: GDLoaderDelegate {
    func loaderDidStart(_ loader: GDLoader) {
        DispatchQueue.main.async {
            self.loadingView.isHidden = false
        }
    }
    
    func loaderDidLoad(_ loader: GDLoader, data: [Data]?) {
        if let d = data?[0] {
            self.mapHandler.listFromData(d)
        }
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
            self.loadAnnotations()
        }
    }
    
    func loaderFailed(_ loader: GDLoader, error: Error) {
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
            self.showError(error)
        }
    }
    
    func loaderCancelled(_ loader: GDLoader) {
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
        }
    }
}
