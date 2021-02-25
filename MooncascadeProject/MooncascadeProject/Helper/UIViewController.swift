//
//  UIViewController.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 25/02/21.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: Metrics.cancelButton.value, style: .cancel)
        let tryAgainAction = UIAlertAction(title: Metrics.tryAgainButton.value, style: .default) { _ in
            completion()
        }
        
        alert.addAction(tryAgainAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}
