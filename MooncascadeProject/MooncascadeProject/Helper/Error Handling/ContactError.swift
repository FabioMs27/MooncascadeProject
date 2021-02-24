//
//  ContactError.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 24/02/21.
//

import Foundation

enum ConctactError: Error {
    case unnableToFetch
}

extension ConctactError: LocalizedError {
    var errorDescription: String? {
        "Unable to fetch contacts from device."
    }
}
