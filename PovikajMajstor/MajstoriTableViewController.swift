//
//  MajstoriTableViewController.swift
//  PovikajMajstor
//
//  Created by Filip Dimitrovski on 1/5/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit
import Parse
var izbranobjectId = String()
class MajstoriTableViewController: UITableViewController {
    

var usernames = [String]()
var objectIds = [String]()
var names = [String]()
var lastnames = [String]()
var distances = [String]()
    
override func viewDidLoad() {
    super.viewDidLoad()
    print(globalprofesija)
           updateTable()
            print(names)
    
    
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "majstorkelija", for: indexPath) as! MajstoriTableViewCell
        cell.ImeLabel.text = names[indexPath.row]
        cell.PrezimeLabel.text = lastnames[indexPath.row]
        cell.RastojanieLabel.text = "Nepoznato"
        
        

        return cell
    }
    @objc func updateTable() {
           self.usernames.removeAll()
           self.objectIds.removeAll()
        self.names.removeAll()
        self.lastnames.removeAll()
        self.distances.removeAll()
           
           let query = PFUser.query()
           //query?.whereKey("username", notEqualTo: PFUser.current()?.username ?? "")
           //print(globalprofesija)
           query?.whereKey("profesija", equalTo: globalprofesija)
           query?.findObjectsInBackground(block: { (users, error) in
               if error != nil {
                   print(error?.localizedDescription ?? "")
               } else if let users = users {
                   for object in users {
                       if let user = object as? PFUser {
                           if let username = user.username {
                               if let objectId = user.objectId {
                                if let name = user["name"]{
                                    
                                    if let lastname = user["lastName"]{
                                        
                                   self.usernames.append(username)
                                   self.objectIds.append(objectId)
                                    self.names.append(name as! String)
                                    self.lastnames.append(lastname as! String)
                                      self.tableView.reloadData()
                                }
                                }
                               }
                           }
                       }
                   }
               }
           })
        
        
       	
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        izbranobjectId = objectIds[indexPath.row]
        performSegue(withIdentifier: "toPortfolioMajstor", sender: nil)
        
    }
    
    override func tableView(_ tableView: UITableView,
             heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return 80
    }
    
    
    @IBAction func refreshtable(_ sender: Any) {
        print("Refresh pressed")
        updateTable()
    }
    

}
