//
//  URLSession.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 23/02/21.
//

import Foundation

//MARK: - URLSession
protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    func dataTask(With request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionTaskProtocol
}
extension URLSession: URLSessionProtocol {
    func dataTask(With request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionTaskProtocol {
        dataTask(with: request, completionHandler: completionHandler) as URLSessionTaskProtocol
    }
}

//MARK: - DataTask
protocol URLSessionTaskProtocol {
    func resume()
}

extension URLSessionTask: URLSessionTaskProtocol { }
