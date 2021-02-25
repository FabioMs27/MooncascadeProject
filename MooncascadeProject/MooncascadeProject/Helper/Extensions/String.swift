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
}
