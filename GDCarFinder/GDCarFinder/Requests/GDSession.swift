//
//  GDSessionManager.swift
//  
//
//  Created by Guglielmo Deletis on 19/04/22.
//

import Foundation

protocol GDSessionHandler: AnyObject {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
    func endDataTask()
}

class GDSession: NSObject {
    private var session: URLSession!
    
    override init() {
        super.init()
        session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
}

// MARK: - URLSessionDelegate
extension GDSession: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        //TODO: add certificate pinning here
        completionHandler(.useCredential, nil)
    }
}

extension GDSession: GDSessionHandler {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.session.dataTask(with: request, completionHandler: completionHandler)
    }
    
    func endDataTask() {
        self.session.invalidateAndCancel()
    }
}
