//
//  MockURLSession.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 03/03/21.
//

import Foundation

class MockURLSession {
    let dataTask = MockURLSessionTask()
    var data = Data()
    var response = URLResponse()
    var error = NetworkError.offline
}

extension MockURLSession: URLSessionProtocol {
    func dataTask(With request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionTaskProtocol {
        completionHandler(data, response, error)
        return dataTask
    }
}

class MockURLSessionTask: URLSessionTaskProtocol {
    func resume() { }
}
