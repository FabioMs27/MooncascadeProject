//
//  EmployeeDAO.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 25/02/21.
//

import Foundation
import Combine

protocol DataStorage {
    func save(employees: [Employee]) throws
    func retrieve() -> Future<[Employee], Error>
}

class EmployeeDAO {
    let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
}

extension EmployeeDAO: DataStorage {
    func save(employees: [Employee]) throws {
        do {
            let data = try self.archive(objects: employees)
            self.userDefaults.set(data, forKey: Metrics.identifier)
        } catch {
            throw DAOError.unnableToSave
        }
    }
    

    func retrieve() -> Future<[Employee], Error> {
        return Future { [weak self] promise in
            do {
                var employees = [Employee]()
                if let data = self?.userDefaults.data(forKey: Metrics.identifier),
                   let savedEmployees: [Employee] = try self?.unarchive(data: data) {
                    employees = savedEmployees
                }
                return promise(.success(employees))
            } catch {
                return promise(.failure(DAOError.userDefaultsEmpty))
            }
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
