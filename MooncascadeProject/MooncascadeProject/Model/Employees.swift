//
//  Employees.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 23/02/21.
//

import Foundation

struct Employees {
    let firstName: String
    let lastName: String
    var fullName: String { firstName + lastName }
    let contactDetails: ContactDetails
    let position: String
    let projects: [String]
}

extension Employees: Comparable {
    static func == (lhs: Employees, rhs: Employees) -> Bool {
        return lhs.fullName == rhs.fullName
    }
    
    static func < (lhs: Employees, rhs: Employees) -> Bool {
        return lhs.lastName < rhs.lastName
    }
}

extension Employees: Decodable {
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

extension ContactDetails: Decodable {
    enum CodingKeys: String, CodingKey {
        case email
        case phone
    }
}
