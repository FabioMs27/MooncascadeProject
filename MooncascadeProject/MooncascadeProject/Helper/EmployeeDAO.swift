//
//  EmployeeDAO.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 25/02/21.
//

import Foundation

class EmployeeDAO {
    let userDefaults: UserDefaults
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    func save(employees: [Employee]) throws {
        do {
            let data = try self.archive(objects: employees)
            self.userDefaults.set(data, forKey: Metrics.identifier.value)
        } catch {
            throw DAOError.unnableToSave
        }
    }
    
    func retrieve() -> (Result<[Employee], Error>) {
        do {
            var employees = [Employee]()
            if let data = userDefaults.data(forKey: Metrics.identifier.value){
                if let savedEmployees: [Employee] = try unarchive(data: data) {
                    employees = savedEmployees
                }
            }
            return .success(employees)
        } catch {
            return .failure(DAOError.userDefaultsEmpty)
        }
    }
}

private extension EmployeeDAO {
    
    func archive<ModelType: Encodable>(objects: [ModelType]) throws -> Data? {
        let encoder = JSONEncoder()
        return try encoder.encode(objects)
    }
    
    func unarchive<ModelType: Decodable>(data: Data) throws -> ModelType? {
        let decoder = JSONDecoder()
        return try decoder.decode(ModelType.self, from: data)
    }
    
}
