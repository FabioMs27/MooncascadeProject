//
//  EmployeeViewModel.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 23/02/21.
//

import Foundation

class EmployeeViewModel {
    @Published var employees = [Employee]()
    let networkManager = NetworkManager()
    
    func fetchEmployees() {
        employees.removeAll()
        fetchFrom(URL: .tallinn)
//        fetchFrom(URL: .tartu)
    }
    
    private func fetchFrom(URL path: URLPath) {
        networkManager.request(urlPath: path, resposeType: Wrapper<Employee>.self) {  [weak self] result in
            switch result {
            case .success(let wrapper):
                self?.employees.append(contentsOf: wrapper.items ?? [])
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
