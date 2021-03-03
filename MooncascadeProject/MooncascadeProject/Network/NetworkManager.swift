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
    
    func request<ModelType: Decodable>(
        urlPath: URLPath,
        resposeType: ModelType.Type,
        completion: @escaping (Result<ModelType, NetworkError>) -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            
            guard let url = urlPath.getURL() else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidURL))
                }
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            self?.session.dataTask(With: request) { [weak self] data, response, error in
                guard let self = self else { return }
                
                guard error == nil else {
                    var networkError: NetworkError = .unknownError
                    if error!.localizedDescription.uppercased().contains("OFFLINE") {
                        networkError = .offline
                    } else if error!.localizedDescription.uppercased().contains("UNSUPPORTED URL") {
                        networkError = .unsupportedURL
                    }
                    DispatchQueue.main.async {
                        completion(.failure(networkError))
                    }
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    DispatchQueue.main.async {
                        completion(.failure(.connectionError))
                    }
                    return
                }
                
                guard let mime = response?.mimeType, mime == "application/json" else {
                    DispatchQueue.main.async {
                        completion(.failure(.invalidResponseType))
                    }
                    return
                }
                DispatchQueue.main.async {
                    guard
                        let data = data,
                        let object: ModelType = self.decode(data: data) else {
                        completion(.failure(.objectNotDecoded))
                        return
                    }
                    completion(.success(object))
                }
            }.resume()
        }
    }
    
    private func decode<ModelType: Decodable>(data: Data) -> ModelType? {
        let decoder = JSONDecoder()
        guard let object = try? decoder.decode(ModelType.self, from: data) else { return nil }
        return object
    }
}
