//
//  ViewController.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 23/02/21.
//

import UIKit
import Combine

class ListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    private let viewModel = EmployeeViewModel()
    private let dataSource = EmployeeDataSource()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        bindViewModel()
        viewModel.fetchEmployees()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow,
              let employee = dataSource.employee(From: indexPath),
              let destination = segue.destination as? DetailViewController else {
            return
        }
        destination.fullname = employee.fullName
        destination.email = employee.contactDetails.email
        destination.phoneNumber = employee.contactDetails.phone
        destination.position = employee.position
        destination.projects = employee.projects ?? []
        destination.contact = employee.contact
    }
    
    private func bindViewModel() {
        viewModel.$employees.sink { [weak self] employees in
            self?.dataSource.update(Employees: employees)
            self?.tableView.reloadData()
        }.store(in: &cancellables)
    }
    
    @IBAction func showContactView(_ sender: UIButton) {
        let touchPoint = sender.convert(CGPoint(x: 0, y: 0), to: self.tableView)
        guard
            let indexPath = tableView.indexPathForRow(at: touchPoint),
            let employee = dataSource.employee(From: indexPath),
            let contactViewController = employee.contact?.getContactView(),
            let navigationController = self.navigationController else {
            return
        }
        navigationController.pushViewController(contactViewController, animated: true)
    }
}

