//
//  GDOperation.swift
//  
//
//  Created by Guglielmo Deletis on 19/04/22.
//

import Foundation

protocol GDOperationHandler: Operation {
    func finish()
}

protocol GDOperationDelegate: AnyObject {
    func operationStarted(_ operation: GDOperation)
    func operationCompleted(_ operation: GDOperation, withData data:Data?)
    func operationFailed(_ operation: GDOperation, withError error:Error?)
    func operationCancelled(_ operation: GDOperation)
}

class GDOperation: Operation, GDOperationHandler {

    private var _isExecuting:Bool = false
    private var _isFinished:Bool = false
    private var _isCancelled:Bool = false
    
    private weak var delegate:GDOperationDelegate?
    
    private var operationAction:GDOperationAction
    
//    override var isAsynchronous: Bool {
//        get {
//            return false
//        }
//    }
    
    override var isExecuting: Bool {
        get {
            return _isExecuting
        }
    }
    
    override var isFinished: Bool {
        get {
            return _isFinished
        }
    }
    
    override var isCancelled: Bool {
        get {
            return _isCancelled
        }
        set {
            _isCancelled = newValue
        }
    }
    
    override func start() {
        if self.isCancelled {
            _isExecuting = false
            _isFinished = true
            self.delegate?.operationCancelled(self)
        }
        else {
            _isExecuting = true
            _isFinished = false
            self.main()
        }
    }
    
    override func main() {
        if self.isCancelled {
            self.finish()
            self.delegate?.operationCancelled(self)
        }
        else {
            self.delegate?.operationStarted(self)
            self.operationAction.main(sessionHandler: GDSession()) { data, error, cancelled in
                if cancelled {
                    self.delegate?.operationCancelled(self)
                }
                else if let e = error {
                    self.delegate?.operationFailed(self, withError: e)
                } else {
                    self.delegate?.operationCompleted(self, withData: data)
                }
                self.finish()
            }
        }
    }
    
    override func cancel() {
        super.cancel()
        self.operationAction.cancel()
        self.finish()
    }
    
    func finish() {
        if self.isExecuting {
            self.willChangeValue(forKey: "isExecuting")
            self.willChangeValue(forKey: "isFinished")
            _isExecuting = false
            _isFinished = true
            self.didChangeValue(forKey: "isFinished")
            self.didChangeValue(forKey: "isExecuting")
        }
    }
    
    // MARK: init
    init(withAction action: GDOperationAction, delegate: GDOperationDelegate?) {
        self.operationAction = action
        self.delegate = delegate
    }
}
