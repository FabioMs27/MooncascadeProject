//
//  DetailViewController.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 24/02/21.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var phoneNumberLabel: UILabel!
    @IBOutlet private weak var positionLabel: UILabel!
    @IBOutlet private weak var projectsLabel: UILabel!
    
    var fullname = String()
    var email = String()
    var phoneNumber: String?
    var position = String()
    var projects = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        fullNameLabel.text = fullname
        emailLabel.text = email
        phoneNumberLabel.text = phoneNumber ?? "No phone number registered."
        positionLabel.text = position
        let formattedProjects = projects.reduce(into: String(), { $0 += "\($01),\n" })
        projectsLabel.text = "Projects: \(formattedProjects)"
    }

}
