//
//  NetworkManager.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 23/02/21.
//

import Foundation

class NetworkManager {
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func request<ModelType:Decodable>(
        urlPath: URLPath,
        resposeType: ModelType.Type,
        completion: @escaping (Result<ModelType, NetworkError>) -> Void) {
        
        guard let url = urlPath.getURL() else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            guard error == nil else {
                var networkError: NetworkError = .unknownError
                if error!.localizedDescription.uppercased().contains("OFFLINE") {
                    networkError = .offline
                }
                completion(.failure(networkError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.connectionError))
                return
            }
            
            guard let mime = response?.mimeType, mime == "application/json" else {
                completion(.failure(.invalidResponseType))
                return
            }
            
            guard
                let data = data,
                let object: ModelType = self.decode(data: data) else {
                completion(.failure(.objectNotDecoded))
                return
            }
            
            completion(.success(object))
        }.resume()
    }
    
    private func decode<ModelType: Decodable>(data: Data) -> ModelType? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let object = try? decoder.decode(ModelType.self, from: data) else { return nil }
        return object
    }
}
