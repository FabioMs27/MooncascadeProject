//
//  EmployeeViewModel.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 23/02/21.
//

import Foundation

class EmployeeViewModel {
    @Published var employees = [Employee]()
    private let networkManager = NetworkManager()
    private let contactManager = ContactManage()
    
    func fetchEmployees() {
        employees.removeAll()
        fetchFrom(URL: .tallinn)
        fetchFrom(URL: .tartu)
    }
    
    private func fetchFrom(URL path: URLPath) {
        networkManager.request(urlPath: path, resposeType: Wrapper<Employee>.self) {  [weak self] result in
            switch result {
            case .success(let wrapper):
                self?.employees.append(contentsOf: wrapper.items ?? [])
                self?.matchContacts()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func matchContacts() {
        contactManager.fetchContacts { [weak self] result in
            switch result {
            case .success(let contacts):
                guard let employees = self?.employees else { return }
                for employee in employees {
                    if let contact = contacts.first(where: { employee == $0 }){
                        if let index = employees.firstIndex(where: { employee.fullName == $0.fullName }) {
                            self?.employees[index].contact = contact
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
