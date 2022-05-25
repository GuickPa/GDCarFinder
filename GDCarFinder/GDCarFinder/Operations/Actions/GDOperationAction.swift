//
//  GDOperationAction.swift
//  
//
//  Created by Guglielmo Deletis on 20/04/22.
//

import Foundation

typealias GDOperationActionCallback = (Data?, Error?, Bool) -> Void

protocol GDOperationAction {
    func main(sessionHandler: GDSessionHandler, callback: @escaping GDOperationActionCallback)
    func cancel()
}

enum GDAPIOperationActionMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

class GDAPIOperationAction: GDOperationAction {
    private var urlRequest:URLRequest
    private var httpDataTask:URLSessionDataTask!
    private var operationCallback:GDOperationActionCallback!
    private weak var sessionHandler: GDSessionHandler!
    
    init(_ urlString: String, method: GDAPIOperationActionMethod) throws {
        guard let url = URL(string: urlString) else {
            throw GDError.badFormat
        }
        self.urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        self.urlRequest.httpMethod = method.rawValue
    }
    
    func main(sessionHandler: GDSessionHandler, callback: @escaping GDOperationActionCallback) {
        self.operationCallback = callback
        self.sessionHandler = sessionHandler
        self.httpDataTask = sessionHandler.dataTask(with: self.urlRequest, completionHandler: { data, response, error in
            if let e = error {
                GDLogger.log("API response error is", e, self.urlRequest.url?.absoluteString ?? "")
            }
            let code = (error as NSError?)?.code ?? 0
            self.operationCallback(data, error, code == -999)
            self.sessionHandler?.endDataTask()
            self.operationCallback = nil
        })
        self.httpDataTask.resume()
    }
    
    func cancel() {
        self.httpDataTask?.cancel()
        self.sessionHandler?.endDataTask()
    }
}
