//
//  GDCache.swift
//  
//
//  Created by Guglielmo Deletis on 04/05/22.
//

import Foundation

struct GDCacheItem {
    var key: String
    var value: Any
    
    init(key: String, value: Any) {
        self.key = key
        self.value = value
    }
}

class GDCache {
    private var _cache: [GDCacheItem] = []
    let capacity: Int = GDConst.cacheSize
    
    var cache: [GDCacheItem] {
        get {
            return _cache
        }
    }
    
    // for singleton
    private static let _instance: GDCache = GDCache()
    static var instance:GDCache {
        get {
            return _instance
        }
    }
    
    private init(){
        
    }
    
    func setValue(_ key: String, value: Any) {
        if let index = _cache.firstIndex(where: { item in
            return item.key == key
        }) {
            _cache[index].value = value
        } else {
            if _cache.count + 1 > capacity {
                _cache.removeFirst()
            }
            
            _cache.append(GDCacheItem(key: key, value: value))
        }
    }
    
    func getValue(_ key: String) -> Any? {
        if let index = _cache.firstIndex(where: { item in
            return item.key == key
        }) {
            return _cache[index].value
        } else {
            return nil
        }
    }
}
