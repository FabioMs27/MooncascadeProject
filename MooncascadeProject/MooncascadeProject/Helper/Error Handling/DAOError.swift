//
//  DAOError.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 25/02/21.
//

import Foundation

enum DAOError: Error {
    case userDefaultsEmpty
    case unnableToSave
    case unnableToFetch
    case objectCouldntDecode
}

extension DAOError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unnableToFetch: return "Last employees couldn't be fetched."
        case .unnableToSave: return "Couldn't save employees."
        case .userDefaultsEmpty: return "There were no previous Employees fetched."
        case .objectCouldntDecode: return "Could't decode object."
        }
    }
}
