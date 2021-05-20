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
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        bindViewModel()
        setupRefreshControl()
        setupSearchBar()
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
    
    @IBAction func showContactView(_ sender: UIButton) {
        let touchPoint = sender.convert(CGPoint(x: 0, y: 0), to: self.tableView)
        guard
            let indexPath = tableView.indexPathForRow(at: touchPoint),
            let employee = dataSource.employee(from: indexPath),
            let contactViewController = employee.contact?.getContactView(),
            let navigationController = self.navigationController else {
            return
        }
        navigationController.pushViewController(contactViewController, animated: true)
    }
}

//MARK: - Setups
private extension ListViewController {
    func setupRefreshControl() {
        refreshControl.attributedTitle = Metrics.refreshText.atributedString
        refreshControl.addAction(
            UIAction { [viewModel, refreshControl] _ in
                viewModel.fetchEmployees()
                refreshControl.beginRefreshing()
            },
            for: .valueChanged
        )
        refreshControl.beginRefreshing()
        tableView.addSubview(refreshControl)
    }
    
    func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Metrics.searchPlaceHolder
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func bindViewModel() {
        viewModel.$employees.sink { [weak self] employees in
            self?.dataSource.update(employees: employees)
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        }.store(in: &cancellables)
        
        viewModel.$error.sink { [showAlert, refreshControl, viewModel] error in
            if let message = error?.localizedDescription {
                showAlert(Metrics.errorTitle, message) {
                    viewModel.fetchEmployees()
                }
                refreshControl.endRefreshing()
                viewModel.retrieveEmployee()
            }
        }.store(in: &cancellables)
    }
}

//MARK: - SearchBar Delegate
extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filter(by: searchText)
    }
}
