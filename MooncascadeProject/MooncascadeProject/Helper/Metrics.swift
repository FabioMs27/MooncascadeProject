//
//  Metrics.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 25/02/21.
//

import Foundation

enum Metrics: String {
    case cancelButton      = "Cancel"
    case tryAgainButton    = "Try again"
    case refreshText       = "Refresh"
    case searchPlaceHolder = "Search Employees"
    case errorTitle        = "Error!"
    
    var value: String { self.rawValue }
}
