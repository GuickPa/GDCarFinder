//
//  GDPicView.swift
//  RickAndMortyAPI
//
//  Created by Guglielmo Deletis on 21/04/22.
//

import UIKit

class GDPicView: UIView {
    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var loadingView: UIImageView!
    
    private var loader:GDLoader!
    
    func load(urlToImage: String, loader: GDLoader, handler: GDOperationQueueHandler) {
        self.loader = loader
        self.loader.delegate = self
        loader.load(urlString: urlToImage, handler: handler)
    }
    
    func cancelLoading() {
        self.loader?.cancel()
    }
}

extension GDPicView: GDLoaderDelegate {
    func loaderDidStart(_ loader: GDLoader) {
        DispatchQueue.main.async {
            self.loadingView.isHidden = false
            let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotateAnimation.fromValue = 0.0
            rotateAnimation.toValue = CGFloat(Double.pi * 2)
            rotateAnimation.isRemovedOnCompletion = false
            rotateAnimation.duration = 3
            rotateAnimation.repeatCount=Float.infinity
            self.loadingView.layer.add(rotateAnimation, forKey: nil)
        }
    }
    
    func loaderDidLoad(_ loader: GDLoader, data: [Data]?) {
        DispatchQueue.main.async {
            self.loadingView.layer.removeAllAnimations()
            self.loadingView.isHidden = true
            if let imageData = data?[0], let image = UIImage(data: imageData) {
                self.imageView.image = image
            }
            self.loader = nil
        }
    }
    
    func loaderFailed(_ loader: GDLoader, error: Error) {
        DispatchQueue.main.async {
            self.loadingView.layer.removeAllAnimations()
            self.loadingView.isHidden = true
            self.imageView.image = UIImage(named: "rickandmorty")
            self.loader = nil
        }
    }
    
    func loaderCancelled(_ loader: GDLoader) {
        
    }
}
