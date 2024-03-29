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
    
    private lazy var viewModel: EmployeeViewModel = {
        EmployeeViewModel(employeeDAO: EmployeeDAO(),
                          contactManager: ContactManager())
    }()
    private lazy var dataSource: EmployeeDataSource = {
        EmployeeDataSource(contactPresenter: self)
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Metrics.searchPlaceHolder
        return searchController
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = Metrics.refreshText.atributedString
        refreshControl.addAction(
            UIAction { [viewModel] _ in
                viewModel.fetchEmployees()
            },
            for: .valueChanged)
        refreshControl.beginRefreshing()
        return refreshControl
    }()
    
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        tableView.addSubview(refreshControl)
        navigationItem.searchController = searchController
        definesPresentationContext = true
        bindViewModel()
        viewModel.fetchEmployees()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let indexPath = tableView.indexPathForSelectedRow,
            let employee = dataSource.employee(from: indexPath),
            let destination = segue.destination as? DetailViewController else {
            return
        }
        segue.forward(employee, to: destination)
    }
}

private extension ListViewController {
    func bindViewModel() {
        viewModel.$employees
            .sink(receiveValue: updateView(employees:))
            .store(in: &cancellables)
        
        viewModel.$error
            .sink(receiveValue: showError(error:))
            .store(in: &cancellables)
    }
    
    func updateView(employees: [Employee]) {
        dataSource.update(Employees: employees)
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func showError(error: Error?) {
        if let message = error?.localizedDescription {
            showAlert(title: Metrics.errorTitle, message: message) { [viewModel] in
                viewModel.fetchEmployees()
            }
            refreshControl.endRefreshing()
            viewModel.retrieveEmployee()
        }
    }
}

extension ListViewController: ContactPresenterDelegate {
    func pushToContactView(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filter(by: searchText)
    }
}
