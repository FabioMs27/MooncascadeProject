//
//  Employee+Comparable+Hashable.swift
//  MooncascadeProject
//
//  Created by Fábio Sousa on 12/08/21.
//

import Foundation
import ContactsUI


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
