//
//  URLSession.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 23/02/21.
//

import Foundation

protocol URLSessionProtocol: URLSession { }
extension URLSession: URLSessionProtocol { }
