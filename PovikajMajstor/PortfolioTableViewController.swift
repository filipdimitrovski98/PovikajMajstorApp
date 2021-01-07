//
//  PortfolioTableViewController.swift
//  PovikajMajstor
//
//  Created by Filip Dimitrovski on 1/5/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//
// var izbranobjectId
import UIKit
import Parse
class PortfolioTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
  */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 222
    }
    @IBAction func pobarajPressed(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        let datum = formatter.string(from: Date())
        
        let baranjeEntry = PFObject(className: "Baranje")
        baranjeEntry["korisnikbaratel"] = PFUser.current()?.objectId
        baranjeEntry["majstorpobaran"] = izbranobjectId
        baranjeEntry["opis"] = globalopis
        baranjeEntry["datumbaranje"] = datum
        baranjeEntry["lokacija"] = globalplace
        baranjeEntry["status"] = "aktivnobaranje"
        
        baranjeEntry.saveInBackground()
        print("Successfull entry for baranje")
    }
    
}
