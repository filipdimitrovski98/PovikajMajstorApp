//
//  KorisnikBaranjaRabotiTableViewController.swift
//  PovikajMajstor
//
//  Created by Filip Dimitrovski on 1/8/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit
import Parse
var sendmajstorId = String()

class KorisnikBaranjaRabotiTableViewController: UITableViewController {
    var objectIds = [String]()
    var majstorIds = [String]()
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
        
        return objectIds.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "korisnikbaranje", for: indexPath) as! BaranjeKorisnikTableViewCell
        let query = PFUser.query()
        //print("korisnik")
        //print(korisnikIds[indexPath.row])
        query?.whereKey("objectId", equalTo: majstorIds[indexPath.row])
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
                            
                            if cell.statusLabel.text == "aktivnobaranje"{
                              cell.statusLabel.textColor = .yellow
                            }
                            else if cell.statusLabel.text == "ispratenaponuda" {
                              cell.statusLabel.textColor = .red
                            }
                            else if cell.statusLabel.text == "zakazanarabota" {
                               cell.statusLabel.textColor = .blue
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
        sendmajstorId = majstorIds[indexPath.row]
        performSegue(withIdentifier: "todetail", sender: nil)
        
    }
    
    @objc func updateTable() {
           self.datumi.removeAll()
           self.objectIds.removeAll()
           self.majstorIds.removeAll()
           
    let query = PFQuery(className: "Baranje")
    query.whereKey("korisnikbaratel", equalTo: PFUser.current()?.objectId ?? "")
    
    query.findObjectsInBackground(block: { (objects, error) in
       if error != nil {
                      print(error?.localizedDescription ?? "")
                  }
        else if let objects = objects {
           if objects.count > 0 {
               for object in objects{
                   self.objectIds.append(object.objectId!)
                   self.majstorIds.append(object["majstorpobaran"] as! String)
                   self.datumi.append(object["datumbaranje"] as! String)
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
    
    
    override func tableView(_ tableView: UITableView,
             heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return 66
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        updateTable()
    }
    
    
   

}
