//
//  Employees.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 23/02/21.
//

import Foundation
import ContactsUI

struct Employee {
    let firstName: String
    let lastName: String
    var fullName: String { "\(firstName) \(lastName)" }
    let contactDetails: ContactDetails
    let position: String
    let projects: [String]?
    var contact: CNContact?
}

extension Employee: Codable {
    enum CodingKeys: String, CodingKey {
        case firstName      = "fname"
        case lastName       = "lname"
        case contactDetails = "contact_details"
        case position
        case projects
    }
}

struct ContactDetails {
    let email: String
    let phone: String?
}

extension ContactDetails: Codable {
    enum CodingKeys: String, CodingKey {
        case email
        case phone
    }
}

struct Wrapper<T: Decodable> {
    let items: T?
}

extension Wrapper: Decodable {
    enum CodingKeys: String, CodingKey {
        case items = "employees"
    }
}
