//
//  MajstorBaranjaTableViewController.swift
//  PovikajMajstor
//
//  Created by Filip Dimitrovski on 1/5/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit

class MajstorBaranjaTableViewController: UITableViewController {
    
    var baranjaIds = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()


    }

   
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return baranjaIds.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "majstorbaranje", for: indexPath) as! MajstorBaranjeTableViewCell

        cell.ImeLabel.text = " "
        cell.PrezimeLabel.text = " "
        cell.DatumLabel.text = " "
        return cell
    }
    


}
