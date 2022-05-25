//
//  GDLogger.swift
//  
//
//  Created by Guglielmo Deletis on 21/04/22.
//

import Foundation

class GDLogger {
    static func log(_ items: Any..., separator: String = " ", terminator: String = "\n") {
#if DEBUG
        print(items, separator: separator, terminator: terminator)
#endif
    }
}
