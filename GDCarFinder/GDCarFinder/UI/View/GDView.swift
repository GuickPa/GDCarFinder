//
//  GDView.swift
//  RickAndMortyAPI
//
//  Created by Guglielmo Deletis on 22/04/22.
//

import UIKit

extension UIView {
    func setUpConstraint(superView: UIView) {
        superView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        let top = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        superView.addConstraints([top, bottom, left, right])
    }
    
    func setUpConstraint(toTopView topView: UIView?, superView: UIView) {
        superView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        var top: NSLayoutConstraint
        if let tv = topView {
            top = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: tv, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        } else {
            top = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        }
        let left = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        // height
        self.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        superView.addConstraints([top, left, right])
    }
}

protocol GDDetailsViewDelegate: AnyObject {
    func viewDidStartLoading(_ detailsView: GDDetailsView)
    func viewDidEndLoading(_ detailsView: GDDetailsView, error: Error?)
}

class GDDetailsView: UIView {
    private weak var _delegate: GDDetailsViewDelegate?
    
    weak var delegate: GDDetailsViewDelegate? {
        get {
            return _delegate
        }
        set {
            _delegate = newValue
        }
    }
}

extension GDDetailsView: GDLoaderDelegate {
    func loaderDidStart(_ loader: GDLoader) {
        self.delegate?.viewDidStartLoading(self)
    }
    
    func loaderDidLoad(_ loader: GDLoader, data: [Data]?) {
        self.delegate?.viewDidEndLoading(self, error: nil)
    }
    
    func loaderFailed(_ loader: GDLoader, error: Error) {
        self.delegate?.viewDidEndLoading(self, error: error)
    }
    
    func loaderCancelled(_ loader: GDLoader) {
        self.delegate?.viewDidEndLoading(self, error: GDError.aborted)
    }
}
