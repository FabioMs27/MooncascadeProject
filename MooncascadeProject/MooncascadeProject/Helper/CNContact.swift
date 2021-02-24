//
//  CNContact.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 24/02/21.
//

import Foundation
import ContactsUI

extension CNContact {
    var fullName: String {
        "\(self.familyName) \(self.givenName)"
    }
    
    func getContactView() -> UINavigationController {
        let contactViewController = CNContactViewController(for: self)
        contactViewController.hidesBottomBarWhenPushed = true
        contactViewController.allowsActions = false
        contactViewController.allowsEditing = false
        let navigationViewController = UINavigationController(rootViewController: contactViewController)

        return navigationViewController
    }
}
