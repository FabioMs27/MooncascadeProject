//
//  EmployeeCell.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 23/02/21.
//

import UIKit
import ContactsUI

protocol ContactPresenterDelegate: AnyObject {
    func pushToContactView(_ vc: UIViewController)
}

class EmployeeCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var initialsLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var phoneNumberLabel: UILabel!
    @IBOutlet private weak var contactButton: UIButton!
    
    weak var contactPresenter: ContactPresenterDelegate?
    static let identifier = "EmployeeCell"
    
    var name = String() {
        willSet {
            nameLabel.text = newValue
            initialsLabel.text = newValue.initials
        }
    }
    var phoneNumber: String? {
        willSet { phoneNumberLabel.text = newValue ?? "" }
    }
    var email = String() {
        willSet { emailLabel.text = newValue }
    }
    var contact: CNContact? {
        willSet { contactButton.isHidden = newValue == nil }
    }
    
    @IBAction func pushToContactView(_ sender: Any) {
        if let vc = contact?.getContactView() {
            contactPresenter?.pushToContactView(vc)
        }
    }
}
