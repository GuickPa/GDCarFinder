//
//  GDOperationManager.swift
//  
//
//  Created by Guglielmo Deletis on 19/04/22.
//

import Foundation

protocol GDOperationQueueHandler {
    func addToQueue(_ operation: GDOperationHandler)
    func clearQueue()
}

class GDOperationQueueManager: GDOperationQueueHandler {
    // for singleton
    private static let _instance: GDOperationQueueManager = GDOperationQueueManager()
    static var instance:GDOperationQueueManager {
        get {
            return _instance
        }
    }
    // queue
    private var queue:OperationQueue
    
    private init(){
        self.queue = OperationQueue()
        self.queue.maxConcurrentOperationCount = 30
    }
    
    func addToQueue(_ operation: GDOperationHandler) {
        if !operation.isFinished {
            self.queue.addOperation(operation)
        }
        else {
        }
    }
    
    func clearQueue() {
        self.queue.cancelAllOperations()
//        if #available(iOS 13.0, *) {
//            self.queue = OperationQueue()
//            self.queue.maxConcurrentOperationCount = 1
//        }
    }
}
