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
    private let networkManager = NetworkManager()
    private let contactManager: ContactLoading
    private let employeeDAO: DataStorage
    
    init(employeeDAO: DataStorage, contactManager: ContactLoading) {
        self.employeeDAO = employeeDAO
        self.contactManager = contactManager
    }
    
    func fetchEmployees() {
        employeesBackup.removeAll()
        fetchFrom(URL: .tallinn)
        fetchFrom(URL: .tartu)
    }
    
    func filter(by searchText: String) {
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
                self?.fetchContacts()
                self?.saveEmployee()
            case .failure(let error):
                self?.error = error
            }
        }
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
            receiveValue: match(contacts:))
            .store(in: &cancellables)
    }
    
    func match(contacts: [CNContact]) {
        employeesBackup
            .enumerated()
            .forEach { (index, employee) in
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
