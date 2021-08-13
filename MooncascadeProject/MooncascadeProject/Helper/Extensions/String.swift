//
//  String.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 24/02/21.
//

import Foundation

extension String {
    var insensitiveCaseFormat: String {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.lowercased().replacingOccurrences(of: " ", with: "")
    }
    
    var initials: String {
        let words = self.components(separatedBy: " ")
        return words
            .reduce(into: String(), { $0 += String($1.first ?? Character("")) })
    }
    
    var atributedString: NSAttributedString {
        NSAttributedString(string: self)
    }
}
