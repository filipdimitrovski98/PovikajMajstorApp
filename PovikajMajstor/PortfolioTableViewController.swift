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
        updateTable()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        updateTable()
    }
    var datumi = [String]()
   // var objectIds = [String]()
    var imageFiles = [PFFileObject]()
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
        imageFiles[indexPath.row].getDataInBackground { (data, error) in
            if let imageData = data {
                if let imageToDisplay = UIImage(data: imageData) {
                    cell.portoflioSlika.image = imageToDisplay
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 222
    }
    
    @IBAction func pobarajPressed(_ sender: Any) {
        if selectedobjectIds.firstIndex(of: sendmajstorId) != nil {
            displayAlert(title: "Cannot call this action", message: "Vekje ima isprateno baranje")
        }
        else {
        selectedobjectIds.append(sendmajstorId)
        
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
    }
    
    @objc func updateTable() {
        self.datumi.removeAll()
        let query = PFQuery(className: "Baranje")
        query.whereKey("majstorpobaran", equalTo: sendmajstorId)
        query.whereKey("status", equalTo: "zavrsenarabota")
        query.findObjectsInBackground(block: { (objects, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            else if let objects = objects {
                if objects.count > 0 {
                    print(objects.count)
                    for object in objects{
                        
                        //self.objectIds.append(object["objectId"] as! String)
                        self.datumi.append(object["datumzavrsuvanje"] as! String)
                        if object["imageFile"] != nil {
                            self.imageFiles.append(object["imageFile"] as! PFFileObject)
                            
                        }
                        
                        
                        //print(object["datumbaranje"])
                        //self.tableView.reloadData()
                        //print(object.objectId as! String)
                        
                        //print(object["korisnikbaratel"] as! String)
                        
                    }
                }
                
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                }
            }
            
        })
        
    }
    func displayAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
