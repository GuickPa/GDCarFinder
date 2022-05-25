//
//  GDDataDecoder.swift
//  
//
//  Created by Guglielmo Deletis on 20/04/22.
//

import Foundation

protocol GDDataDecoder {
    func decode<T:Decodable>(data: Data, classType: T.Type) -> T?
}

class GDGenericDataDecoder: GDDataDecoder {
    func decode<T:Decodable>(data: Data, classType: T.Type) -> T? {
        let decoder = JSONDecoder()
        do {
            let item = try decoder.decode(classType, from: data)
            return item
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
