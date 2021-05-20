//
//  URLPath.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 23/02/21.
//

import Foundation

enum URLPath: String {
    case tallinn
    case tartu
    
    func getURL() -> URL? {
        URL(string: "https://\(self.rawValue)-jobapp.aw.ee/employee_list/")
    }
}
