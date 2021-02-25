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
    private let employeeDAO = EmployeeDAO()
    
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
    
    
}

//MARK: - Network Request
private extension EmployeeViewModel {
    func fetchFrom(URL path: URLPath) {
        networkManager.request(urlPath: path, resposeType: Wrapper<Employee>.self) {  [weak self] result in
            switch result {
            case .success(let wrapper):
                self?.employeesBackup.append(contentsOf: wrapper.items ?? [])
                self?.matchContacts()
                self?.saveEmployee()
            case .failure(let error):
                self?.error = error
            }
        }
    }
}

//MARK: - Contact Manager
private extension EmployeeViewModel {
    func matchContacts() {
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

//MARK: - Data Access Object
extension EmployeeViewModel {
    private func saveEmployee() {
        do {
            try employeeDAO.save(employees: employeesBackup)
        } catch {
            self.error = error
        }
    }
    func retrieveEmployee() {
        let result = employeeDAO.retrieve()
        switch result {
        case .success(let employees):
            self.employeesBackup.removeAll()
            self.employeesBackup = employees
        case .failure(let error):
            self.error = error
        }
    }
}
