//
//  DetailViewController.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 24/02/21.
//

import UIKit
import ContactsUI

class DetailViewController: UIViewController {
    
    @IBOutlet private weak var initialsLabel: UILabel!
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var phoneNumberLabel: UILabel!
    @IBOutlet private weak var positionLabel: UILabel!
    @IBOutlet private weak var projectsLabel: UILabel!
    @IBOutlet private weak var contactButton: UIButton!
    
    var fullname = String()
    var email = String()
    var phoneNumber: String?
    var position = String()
    var projects = [String]()
    var contact: CNContact?

    override func viewDidLoad() {
        super.viewDidLoad()
        fullNameLabel.text = fullname
        initialsLabel.text = fullname.initials
        emailLabel.text = email
        phoneNumberLabel.text = phoneNumber ?? "No phone number registered."
        positionLabel.text = position
        var formattedProjects = projects.reduce(into: String(), { $0 += "\($01), " })
        if !formattedProjects.isEmpty {
            formattedProjects.removeLast()
            formattedProjects.removeLast()
        }
        projectsLabel.text = formattedProjects.isEmpty ? "No projects registered." : formattedProjects
        contactButton.isHidden = contact == nil ? true : false
    }

    @IBAction func showContactView(_ sender: Any) {
        guard let contactViewController = contact?.getContactView(),
              let navigationController = self.navigationController else {
            return
        }
        navigationController.pushViewController(contactViewController, animated: true)
    }
}
