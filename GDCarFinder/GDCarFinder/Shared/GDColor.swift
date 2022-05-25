//
//  GDColor.swift
//  
//
//  Created by Guglielmo Deletis on 22/04/22.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    convenience init(hexString: String){
        var scanner:Scanner?
        if (hexString.hasPrefix("#")) {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            scanner = Scanner(string: String(hexString[start...hexString.endIndex]))
        } else {
            scanner = Scanner(string: hexString)
        }
        
        var color: UInt64 = 0
        scanner!.scanHexInt64(&color)
        self.init(rgb:Int(color))
    }
}
