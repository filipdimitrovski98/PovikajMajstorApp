//
//  BaranjeKorisnikTableViewCell.swift
//  PovikajMajstor
//
//  Created by Filip Dimitrovski on 1/8/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit

class BaranjeKorisnikTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
  
    @IBOutlet weak var imeLabel: UILabel!
    @IBOutlet weak var prezimeLabel: UILabel!
    
    @IBOutlet weak var datumLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
}
