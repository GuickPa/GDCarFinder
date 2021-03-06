//
//  GDLoader.swift
//
//
//  Created by Guglielmo Deletis on 20/04/22.
//

import Foundation

protocol GDLoader {
    var delegate: GDLoaderDelegate! { get set }
    var isLoading: Bool { get }
    var hasFailed: Bool { get }
    func load(urlString: String, handler: GDOperationQueueHandler)
    func load(urlStrings: [String], handler: GDOperationQueueHandler)
    func cancel()
}

protocol GDLoaderDelegate: AnyObject {
    func loaderDidStart(_ loader: GDLoader)
    func loaderDidLoad(_ loader: GDLoader, data: [Data]?)
    func loaderFailed(_ loader: GDLoader, error: Error)
    func loaderCancelled(_ loader: GDLoader)
}

class GDDataLoader {
    weak var _delegate: GDLoaderDelegate!
    var _isLoading: Bool = false
    var _hasFailed: Bool = false
    var operations: [GDOperation] = []
    var data:[Data] = []
    
    weak var delegate: GDLoaderDelegate! {
        get {
            return _delegate
        }
        set {
            _delegate = newValue
        }
    }
    
    var isLoading: Bool { get { return _isLoading } }
    var hasFailed: Bool { get { return _hasFailed } }
}

//MARK: GDLoader
extension GDDataLoader: GDLoader {
    func load(urlString: String, handler: GDOperationQueueHandler) {
        self._hasFailed = false
        self._isLoading = true
        do {
            self.data = []
            let action = try GDAPIOperationAction(urlString, method: .get)
            self.operations = [GDOperation(withAction: action, delegate: self)]
            handler.addToQueue(self.operations[0])
        }
        catch let ex {
            self._isLoading = false
            self._hasFailed = true
            self.delegate.loaderFailed(self, error: ex)
            self.operations = []
        }
    }
    
    func load(urlStrings: [String], handler: GDOperationQueueHandler) {
        self.operations = []
        self._hasFailed = false
        self._isLoading = true
        do {
            self.data = []
            try urlStrings.forEach {
                let action = try GDAPIOperationAction($0, method: .get)
                let operation = GDOperation(withAction: action, delegate: self)
                self.operations.append(operation)
                handler.addToQueue(operation)
            }
        }
        catch let ex {
            self._isLoading = false
            self._hasFailed = true
            self.delegate.loaderFailed(self, error: ex)
            self.operations = []
        }
    }
    
    func cancel() {
        self.operations.forEach{ $0.cancel() }
        self.operations = []
        self._isLoading = false
        self._hasFailed = false
    }
}

//MARK: GDOperationDelegate
extension GDDataLoader: GDOperationDelegate {
    func operationStarted(_ operation: GDOperation) {
        self._isLoading = true
        self.delegate.loaderDidStart(self)
    }
    
    func operationCompleted(_ operation: GDOperation, withData data: Data?) {
        self._isLoading = false
        self.data.append(data!)
        if self.data.count == self.operations.count {
            self.delegate.loaderDidLoad(self, data: self.data)
            self.operations = []
        }
    }
    
    func operationFailed(_ operation: GDOperation, withError error: Error?) {
        self._isLoading = false
        self._hasFailed = true
        self.delegate.loaderFailed(self, error: error!)
        self.cancel()
    }
    
    func operationCancelled(_ operation: GDOperation) {
        self._isLoading = false
        self.delegate.loaderCancelled(self)
        self.cancel()
    }
}
