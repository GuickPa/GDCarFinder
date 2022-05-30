//
//  GDIconView.swift
//  GDCarFinder
//
//  Created by Guglielmo Deletis on 30/05/22.
//

import UIKit

class GDIconView: UIImageView {
    
    override init(image: UIImage?) {
        super.init(image: image)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        //self.layer.cornerRadius = self.frame.size.width/2
        let halfSize:CGFloat = min( bounds.size.width/2, bounds.size.height/2)
        let desiredLineWidth:CGFloat = 3 // your desired value
            
        let circlePath = UIBezierPath(
                arcCenter: CGPoint(x:halfSize,y:halfSize),
                radius: CGFloat( halfSize - (desiredLineWidth/2) ),
                startAngle: CGFloat(0),
                endAngle:CGFloat(Double.pi * 2),
                clockwise: true)
    
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
            
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = GDConst.iconBGColor.cgColor
        shapeLayer.lineWidth = desiredLineWidth
    
        layer.insertSublayer(shapeLayer, at: 1)
    }
    
}
