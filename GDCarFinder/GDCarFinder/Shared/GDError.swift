//
//  GDError.swift
//  
//
//  Created by Guglielmo Deletis on 19/04/22.
//

import Foundation

enum GDError: Error {
    case instanceError
    case methodNotAllowed
    case badFormat
    case aborted
}

extension GDError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .instanceError:
            return GDConst.localizedString("gd_error_instance")
        case .methodNotAllowed:
            return GDConst.localizedString("gd_error_unallowed_method")
        case .badFormat:
            return GDConst.localizedString("gd_error_bad_format")
        case .aborted:
            return GDConst.localizedString("gd_error_aborted")
        }
    }
}
