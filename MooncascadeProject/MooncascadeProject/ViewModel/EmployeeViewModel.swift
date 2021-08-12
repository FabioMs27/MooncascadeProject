//
//  EmployeeViewModel.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 23/02/21.
//

import Combine
import ContactsUI

class EmployeeViewModel {
    @Published var employees = [Employee]()
    @Published var error: Error?
    private var employeesBackup = [Employee]() {
        willSet { employees = newValue }
    }
    private var cancellables = Set<AnyCancellable>()
    private let contactManager: ContactLoading
    private let employeeDAO: DataStorage
    
    init(employeeDAO: DataStorage, contactManager: ContactLoading) {
        self.employeeDAO = employeeDAO
        self.contactManager = contactManager
    }

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
        Publishers.Zip(tallinn, tartu)
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
            .store(in: &cancellables)
    }
}

//MARK: - Contact Manager
private extension EmployeeViewModel {
    func fetchContacts() {
        contactManager.fetchContacts()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.error = error
                case .finished: ()
                }
            },
            receiveValue: matchEmployees(with:))
            .store(in: &cancellables)
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
        employeeDAO.retrieve()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.error = error
                case .finished: ()
                }
            }, receiveValue: { employees in
                self.employeesBackup.removeAll()
                self.employeesBackup = employees
            })
            .store(in: &cancellables)
    }
}
