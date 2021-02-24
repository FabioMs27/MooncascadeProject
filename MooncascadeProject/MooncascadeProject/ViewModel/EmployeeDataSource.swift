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
    
    func update(Employees employees: [Employee]) {
        sections.removeAll()
        let uniqueEmployees = employees
            .reduce(into: Set<Employee>(), { $0.insert($1) })
            .sorted(by: <)
        for employee in uniqueEmployees {
            let position = employee.position
            if var employees = sections[position] {
                employees.append(employee)
                sections[position] = employees
            } else {
                sections[position] = [employee]
            }
        }
    }
}

extension EmployeeDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let position = positions[section]
        return sections[position]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let position = positions[indexPath.section]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell") as? EmployeeCell,
              let employee = sections[position]?[indexPath.row] else {
            fatalError("Employee cell isn't registered")
        }
        cell.name = employee.fullName
        return cell
    }
}
