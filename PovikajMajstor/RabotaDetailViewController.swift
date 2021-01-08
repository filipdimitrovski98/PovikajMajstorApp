//
//  RabotaDetailViewController.swift
//  PovikajMajstor
//
//  Created by Filip Dimitrovski on 1/8/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit
import Parse
//sendmajstorId sendobjectId
class RabotaDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateview()
    
    
    
    }
    var status = String()
    
    @IBOutlet weak var imeLabel: UILabel!
    @IBOutlet weak var prezimeLabel: UILabel!
    @IBOutlet weak var opisLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var telefonLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var datumLabelA: UILabel!
    @IBOutlet weak var datumLabelB: UILabel!
    @IBOutlet weak var datumInfoLabel: UILabel!
    @IBOutlet weak var cenaLabel: UILabel!
    @IBOutlet weak var cenaInfoLabel: UILabel!
    @IBOutlet weak var profesijaLabel: UILabel!
    
    @IBOutlet weak var prifatiButton: UIButton!
    @IBOutlet weak var odbijButton: UIButton!

    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var otkaziButton: UIButton!
    
    @IBAction func prifatiPressed(_ sender: Any) {
        
    }

    @IBAction func odbijPressed(_ sender: Any) {
        
    }
    
    @IBAction func otkaziPressed(_ sender: Any) {
        
    }
    
    func updateview(){
        let query = PFQuery(className:"Baranje")
               query.getObjectInBackground(withId: sendobjectId) { (baranje: PFObject?, error: Error?) in
                   if let error = error {
                       print(error.localizedDescription)
                   } else if let baranje = baranje {
                       self.status = baranje["status"] as! String
                       if self.status == "aktivnobaranje" {
                           
                        self.cenaInfoLabel.isHidden = true
                           self.datumInfoLabel.isHidden = true
                           self.datumLabelB.isHidden = true
                           self.cenaLabel.isHidden = true
                           self.prifatiButton.isHidden = true
                           self.odbijButton.isHidden = true
                           self.image.isHidden = true
                           self.otkaziButton.isHidden = false
                       }
                       else if self.status == "ispratenaponuda" {
                           self.datumInfoLabel.isHidden = false
                           self.datumInfoLabel.text = "Ponuden datum"
                           self.datumLabelB.isHidden = false
                           self.cenaLabel.isHidden = false
                        self.cenaInfoLabel.isHidden = false
                           self.prifatiButton.isHidden = false
                           self.odbijButton.isHidden = false
                           self.image.isHidden = true
                           self.otkaziButton.isHidden = true
                           self.datumLabelB.text = baranje["datumponuda"] as? String
                           self.cenaLabel.text = baranje["cena"] as? String
                           
                           
                       }
                       else if self.status == "zakazanarabota" {
                           self.datumInfoLabel.isHidden = false
                           self.datumInfoLabel.text = "Zakazan datum"
                           self.datumLabelB.isHidden = false
                           self.cenaLabel.isHidden = false
                        self.cenaInfoLabel.isHidden = false
                           self.prifatiButton.isHidden = true
                           self.odbijButton.isHidden = true
                           self.image.isHidden = true
                           self.otkaziButton.isHidden = true
                           self.datumLabelB.text = baranje["datumponuda"] as? String
                           self.cenaLabel.text = baranje["cena"] as? String
                           
                           
                       }
                       else if self.status == "zavrsenarabota" {
                           self.datumInfoLabel.isHidden = false
                           self.datumInfoLabel.text = "Zavrseno na datum"
                           self.datumLabelB.isHidden = false
                           self.cenaLabel.isHidden = false
                        self.cenaInfoLabel.isHidden = false
                           self.prifatiButton.isHidden = true
                           self.odbijButton.isHidden = true
                           self.image.isHidden = false
                           self.otkaziButton.isHidden = true
                           self.datumLabelB.text = baranje["datumzavrsuvanje"] as? String
                           self.cenaLabel.text = baranje["cena"] as? String
                          //if let image = baranje[]
                           //self.image
                           
                       }
                    
                       let userquery = PFUser.query()
                       //print("korisnik")
                       //print(korisnikIds[indexPath.row])
                       userquery?.whereKey("objectId", equalTo: sendmajstorId)
                           userquery?.findObjectsInBackground(block: { (users,error) in
                               if error != nil {
                                   print(error?.localizedDescription ?? "")
                               }
                               else if let users = users {
                                   let user = users[0]
                                   self.imeLabel.text = user["name"] as? String
                                   self.prezimeLabel.text = user["lastName"] as? String
                                   self.telefonLabel.text = user["phoneNumber"] as? String
                                self.emailLabel.text = user["username"] as? String
                                   self.profesijaLabel.text = user["profesija"] as? String
                                   
                                   
                                   
                               }
                               
                           })
                       
                       self.opisLabel.text = baranje["opis"] as? String
                       self.datumLabelA.text = baranje["datumbaranje"] as? String
                       self.statusLabel.text = baranje["status"] as? String
                       
                       
                       
                       
                   }
               }
        
        
    }


 }
