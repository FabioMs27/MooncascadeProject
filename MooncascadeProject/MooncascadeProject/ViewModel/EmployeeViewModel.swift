//
//  EmployeeViewModel.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 23/02/21.
//

import Foundation

class EmployeeViewModel {
    @Published var employees = [Employee]()
    @Published var error: Error?
    private var employeesBackup = [Employee]() {
        willSet { employees = newValue }
    }
    private let networkManager = NetworkManager()
    private let contactManager = ContactManage()
    
    func fetchEmployees() {
        employeesBackup.removeAll()
        fetchFrom(URL: .tallinn)
        fetchFrom(URL: .tartu)
    }
    
    func filter(By searchText: String) {
        if searchText.isEmpty { return }
        let formattedText = searchText.insensitiveCaseFormat
        employees = employeesBackup.filter { formattedText == $0 }
    }
    
    private func fetchFrom(URL path: URLPath) {
        networkManager.request(urlPath: path, resposeType: Wrapper<Employee>.self) {  [weak self] result in
            switch result {
            case .success(let wrapper):
                self?.employeesBackup.append(contentsOf: wrapper.items ?? [])
                self?.matchContacts()
            case .failure(let error):
                self?.error = error
            }
        }
    }
    
    private func matchContacts() {
        contactManager.fetchContacts { [weak self] result in
            switch result {
            case .success(let contacts):
                guard let employees = self?.employeesBackup else { return }
                for employee in employees {
                    if let contact = contacts.first(where: { employee == $0 }){
                        if let index = employees.firstIndex(where: { employee.fullName == $0.fullName }) {
                            self?.employeesBackup[index].contact = contact
                        }
                    }
                }
            case .failure(let error):
                self?.error = error
            }
        }
    }
}
