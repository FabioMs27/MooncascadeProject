//
//  EmployeeViewModel.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 23/02/21.
//

import Foundation
import Combine
import ContactsUI

class EmployeeViewModel {
    @Published var employees = [Employee]()
    @Published var error: Error?
    private var employeesBackup = [Employee]() {
        willSet { employees = newValue }
    }
    private var cancellationToken: AnyCancellable?
    private let contactManager = ContactManage()
    private let employeeDAO = EmployeeDAO()
    
    func filter(by searchText: String) {
        if searchText.isEmpty { return }
        let formattedText = searchText.insensitiveCaseFormat
        employees = employeesBackup.filter { formattedText == $0 }
    }
}

//MARK: - Network Request
extension EmployeeViewModel {
    func fetchEmployees() {
        let apiRequest = APIRequest<[Employee]>()
        let tallinn = apiRequest.request(path: .tallinn)
        let tartu = apiRequest.request(path: .tartu)
        cancellationToken = Publishers.Zip(tallinn, tartu)
            .mapError { [weak self] (error) -> Error in
                self?.error = error
                return error
            }
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] (tallinnMembers, tartuMembers) in
                    self?.employeesBackup = tallinnMembers + tartuMembers
                    self?.fetchContacts()
                }
            )
    }
}

//MARK: - Contact Manager
private extension EmployeeViewModel {
    func fetchContacts() {
        contactManager.fetchContacts { [weak self] result in
            switch result {
            case .success(let contacts):
                self?.matchEmployees(with: contacts)
            case .failure(let error):
                self?.error = error
            }
        }
    }
    func matchEmployees(with contacts: [CNContact]) {
        for (index, employee) in employeesBackup.enumerated() {
            if let contact = contacts.first(where: { employee == $0 }) {
                employeesBackup[index].contact = contact
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
