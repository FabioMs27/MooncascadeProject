//
//  NetworkManager.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 23/02/21.
//

import Foundation
import Combine
import UIKit

protocol NetworkRequest {
    associatedtype ModelType: Decodable
    func request(path: URLPath) -> AnyPublisher<ModelType, Error>
    func decode(_ data: Data) throws -> ModelType
}

extension NetworkRequest {
    func request(path: URLPath) -> AnyPublisher<ModelType, Error> {
        guard let url = path.getURL() else {
            fatalError("Invalid URL!")
        }
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { result -> ModelType in
                guard let httpResponse = result.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw NetworkError.invalidResponseType
                }
                let value: ModelType = try decode(result.data)
                return value
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct APIRequest<ModelType: Decodable>: NetworkRequest {
    func decode(_ data: Data) throws -> ModelType {
        let decoder = JSONDecoder()
        guard let wrapper = try? decoder.decode(Wrapper<ModelType>.self, from: data),
              let items = wrapper.items else {
            throw NetworkError.objectNotDecoded
        }
        return items
    }
}
