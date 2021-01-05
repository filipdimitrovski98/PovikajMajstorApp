//
//  MajstoriTableViewCell.swift
//  PovikajMajstor
//
//  Created by Filip Dimitrovski on 1/5/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit

class MajstoriTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    
    }

    @IBOutlet weak var ImeLabel: UILabel!
    
    @IBOutlet weak var PrezimeLabel: UILabel!
    
    @IBOutlet weak var RastojanieLabel: UILabel!
}
