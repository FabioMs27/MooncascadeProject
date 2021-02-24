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
    
    private func bindViewModel() {
        viewModel.$employees.sink { [weak self] employees in
            self?.dataSource.update(Employees: employees)
            self?.tableView.reloadData()
        }.store(in: &cancellables)
    }

}

