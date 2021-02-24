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
    var fullName: String { "\(lastName) \(firstName)" }
    let contactDetails: ContactDetails
    let position: String
    let projects: [String]?
    var contact: CNContact?
}

extension Employee: Comparable, Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(fullName.hashValue)
    }
    
    static func == (lhs: String, rhs: Employee) -> Bool {
        let projects = rhs.projects?.reduce(into: String(), { $0 += $1 })
        return rhs.fullName.insensitiveCaseFormat.contains(lhs)
            || rhs.position.insensitiveCaseFormat.contains(lhs)
            || rhs.contactDetails.email.insensitiveCaseFormat.contains(lhs)
            || (projects ?? "").insensitiveCaseFormat.contains(lhs)
    }
    
    static func == (lhs: Employee, rhs: Employee) -> Bool {
        return lhs.fullName == rhs.fullName
    }
    
    static func == (lhs: Employee, rhs: CNContact) -> Bool {
        return lhs.fullName.insensitiveCaseFormat == rhs.fullName.insensitiveCaseFormat
    }
    
    static func < (lhs: Employee, rhs: Employee) -> Bool {
        return lhs.lastName < rhs.lastName
    }
}

extension Employee: Decodable {
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

struct Wrapper<T: Decodable> {
    let items: [T]?
}

extension Wrapper: Decodable {
    enum CodingKeys: String, CodingKey {
        case items = "employees"
    }
}
