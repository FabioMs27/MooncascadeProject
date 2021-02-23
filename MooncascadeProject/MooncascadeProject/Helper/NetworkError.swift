//
//  NetworkError.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 23/02/21.
//

import Foundation

enum NetworkError: Error {
    case offline
    case unknownError
    case invalidResponseType
    case objectNotDecoded
    case connectionError
    case invalidURL
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .offline: return "The Device is not connected to the internet."
        case .unknownError: return "Connection error unknown."
        case .invalidResponseType: return "The data returned is invalid."
        case .objectNotDecoded: return "The object couldn't be decoded."
        case .connectionError: return "Connection error."
        case .invalidURL: return "The URL provided is invalid."
        }
    }
}
