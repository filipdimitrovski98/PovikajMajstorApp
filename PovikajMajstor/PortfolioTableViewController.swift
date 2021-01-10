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
    var datumi = [String]()
    //var images =
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datumi.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "portfolio", for: indexPath) as! PortfolioTableViewCell

        cell.datum.text = datumi[indexPath.row]
        //cell.portoflioSlika = 

        return cell
    }
  
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
        baranjeEntry["majstorpobaran"] = sendmajstorId
        baranjeEntry["opis"] = globalopis
        baranjeEntry["datumbaranje"] = datum
        baranjeEntry["lokacija"] = globalplace
        baranjeEntry["status"] = "aktivnobaranje"
        
        baranjeEntry.saveInBackground()
        print("Successfull entry for baranje")
    }
    
    @objc func updateTable() {
        self.datumi.removeAll()
    let query = PFQuery(className: "Baranje")
    query.whereKey("majstorpobaran", equalTo: PFUser.current()?.objectId ?? "")
    query.whereKey("status", equalTo: "aktivnobaranje")
    query.findObjectsInBackground(block: { (objects, error) in
       if error != nil {
                      print(error?.localizedDescription ?? "")
                  }
        else if let objects = objects {
           if objects.count > 0 {
               for object in objects{
                   
                self.datumi.append(object["datumzavrsuvanje"] as! String)
                   //print(object["datumbaranje"])
                   self.tableView.reloadData()
                   //print(object.objectId as! String)
                   
                   //print(object["korisnikbaratel"] as! String)
                   
               }
           }
           
           //self.tableView.reloadData()
                               }
           
           })

       }
    
}
