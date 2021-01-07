//
//  MajstorBaranjaTableViewController.swift
//  PovikajMajstor
//
//  Created by Filip Dimitrovski on 1/5/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit
import Parse

class MajstorBaranjaTableViewController: UITableViewController {
    
    var objectIds = [String]()
    var korisnikIds = [String]()
    var datumi = [String]()
    var ime = String()
    var prezime = String()
    var datum = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateTable()
        
        

    }

   
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("brredovi")
        //print(objectIds.count)
        return objectIds.count
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "majstorbaranje", for: indexPath) as! MajstorBaranjeTableViewCell
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
                            
                            
                            cell.ImeLabel.text = name as? String
                            cell.PrezimeLabel.text = lastname as? String
                            cell.DatumLabel.text = self.datumi[indexPath.row]
                        }
                    
                    }
                }
            }
            
            }
        
        }
        )
      
        return cell
    }
    @objc func updateTable() {
        self.datumi.removeAll()
        self.objectIds.removeAll()
        self.korisnikIds.removeAll()
        
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
                self.objectIds.append(object.objectId!)
                self.korisnikIds.append(object["korisnikbaratel"] as! String)
                self.datumi.append(object["datumbaranje"] as! String)
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
    
    @IBAction func logoutPressed(_ sender: Any) {
        PFUser.logOut()
               print("Logout Success")
               navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rabotiButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        updateTable()
        print(korisnikIds)
    }
    
    
}
