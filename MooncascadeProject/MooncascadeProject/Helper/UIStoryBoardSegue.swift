//
//  UIStoryBoardSegue.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 25/02/21.
//

import UIKit

extension UIStoryboardSegue {
    func forward(_ employee: Employee, to destination: DetailViewController) {
        destination.fullname = employee.fullName
        destination.email = employee.contactDetails.email
        destination.phoneNumber = employee.contactDetails.phone
        destination.position = employee.position
        destination.projects = employee.projects ?? []
        destination.contact = employee.contact
    }
}
