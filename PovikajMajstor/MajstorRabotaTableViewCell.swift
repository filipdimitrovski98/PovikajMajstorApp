//
//  MajstorRabotaTableViewCell.swift
//  PovikajMajstor
//
//  Created by Filip Dimitrovski on 1/10/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit

class MajstorRabotaTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var imeLabel: UILabel!
    
    @IBOutlet weak var prezimeLabel: UILabel!
    @IBOutlet weak var datumLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
}
