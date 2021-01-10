//
//  MajstorRabotiTableViewController.swift
//  PovikajMajstor
//
//  Created by Filip Dimitrovski on 1/10/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit
import Parse
//sendobjectId
//sendkorisnikId
class MajstorRabotiTableViewController: UITableViewController {

    var objectIds = [String]()
    var korisnikIds = [String]()
    var datumi = [String]()
    var statusi = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTable()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return objectIds.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rabotakelija", for: indexPath) as! MajstorRabotaTableViewCell
        let query = PFUser.query()
        //print("korisnik")
        //print(korisnikIds[indexPath.row])
        query?.whereKey("objectId", equalTo: korisnikIds[indexPath.row])
        query?.findObjectsInBackground(block: { (users, error) in
        if error != nil {
            print(error?.localizedDescription ?? "")
        } else if let users = users {
            //print(users.count)
            for object in users {
                if let user = object as? PFUser {
                    if let name = user.value(forKey: "name"){
                       // print(user.value(forKey: "name") as! String)
                        //print(user.value(forKey: "lastName") as! String)
                        if let lastname = user.value(forKey: "lastName") {
                            
                            
                            cell.imeLabel.text = name as? String
                            cell.prezimeLabel.text = lastname as? String
                            cell.datumLabel.text = self.datumi[indexPath.row]
                            cell.statusLabel.text = self.statusi[indexPath.row]
                            
                            if cell.statusLabel.text == "zakazanarabota"{
                              cell.statusLabel.textColor = .red
                            }
                            else if cell.statusLabel.text == "zavrsenarabota" {
                              cell.statusLabel.textColor = .green
                            }
                        }
                    
                    }
                }
            }
            
            }
        
        }
        )
      
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sendobjectId = objectIds[indexPath.row]
        sendkorisnikId = korisnikIds[indexPath.row]
        performSegue(withIdentifier: "tomajstorrabotadetail", sender: nil)
        
    }
    
    override func tableView(_ tableView: UITableView,
             heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return 91
    }
    
    @objc func updateTable() {
           self.datumi.removeAll()
           self.objectIds.removeAll()
           self.korisnikIds.removeAll()
        self.statusi.removeAll()
           
    let query = PFQuery(className: "Baranje")
    query.whereKey("majstorpobaran", equalTo: PFUser.current()?.objectId ?? "")
        
        query.whereKey("status", contains: "rabota")
    query.findObjectsInBackground(block: { (objects, error) in
       if error != nil {
                      print(error?.localizedDescription ?? "")
                  }
        
        else if let objects = objects {
        print(objects.count)
        if objects.count > 0 {
            
               for object in objects{
                
                //print(object.objectId)
                self.objectIds.append(object.objectId!)
                
                self.korisnikIds.append(object["korisnikbaratel"] as! String)
                   self.datumi.append(object["datumponuda"] as! String)
                self.statusi.append(object["status"] as! String)
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
