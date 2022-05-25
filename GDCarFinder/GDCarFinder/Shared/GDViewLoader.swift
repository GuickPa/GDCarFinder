//
//  GDViewLoader.swift
//  
//
//  Created by Guglielmo Deletis on 21/04/22.
//

import UIKit

protocol GDViewLoader {
    static func loadView<T:UIView>(nibName: String?) -> T
}

class GDCustomViewLoader: GDViewLoader {
    static func loadView<T:UIView>(nibName: String? = nil) -> T {
        let name = nibName ?? String(describing: T.self)
        return Bundle.main.loadNibNamed(name, owner: nil, options: nil)![0] as! T
    }
}
