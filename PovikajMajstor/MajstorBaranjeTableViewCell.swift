//
//  MajstorBaranjeTableViewCell.swift
//  PovikajMajstor
//
//  Created by Filip Dimitrovski on 1/5/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit

class MajstorBaranjeTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBOutlet weak var ImeLabel: UILabel!
    
    @IBOutlet weak var PrezimeLabel: UILabel!
    @IBOutlet weak var DatumLabel: UILabel!
    
}
