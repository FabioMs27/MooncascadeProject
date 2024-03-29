//
//  EmployeeDataSource.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 23/02/21.
//

import UIKit

class EmployeeDataSource: NSObject {
    private var sections = [String: [Employee]]()
        
    private var positions: [String] {
        sections.keys.sorted()
    }
    
    private weak var contactPresenter: ContactPresenterDelegate?
    
    init(contactPresenter: ContactPresenterDelegate) {
        self.contactPresenter = contactPresenter
    }
    
    func update(Employees employees: [Employee]) {
        sections.removeAll()
        let uniqueEmployees = employees
            .reduce(into: Set<Employee>(), { $0.insert($1) })
            .sorted(by: <)
        sections = Dictionary(grouping: uniqueEmployees,
                              by: { $0.position })
    }
    
    func employee(from indexPath: IndexPath) -> Employee? {
        let position = self.positions[indexPath.section]
        return self.sections[position]?[indexPath.row]
    }
}

extension EmployeeDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        positions[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let position = positions[section]
        return sections[position]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let position = positions[indexPath.section]
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell") as? EmployeeCell,
            let employee = sections[position]?[indexPath.row] else {
            fatalError("Employee cell isn't registered")
        }
        cell.name = employee.fullName
        cell.phoneNumber = employee.contactDetails.phone
        cell.email = employee.contactDetails.email
        cell.contact = employee.contact
        cell.contactPresenter = contactPresenter
        return cell
    }
}
