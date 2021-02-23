//
//  EmployeeCell.swift
//  MooncascadeProject
//
//  Created by Fábio Maciel de Sousa on 23/02/21.
//

import UIKit

class EmployeeCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    
    var name = String() {
        willSet { nameLabel.text = newValue }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
