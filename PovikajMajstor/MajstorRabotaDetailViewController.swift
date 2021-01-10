//
//  MajstorRabotaDetailViewController.swift
//  PovikajMajstor
//
//  Created by Filip Dimitrovski on 1/10/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit
import Parse

class MajstorRabotaDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        updatedata()

    }
    
    @IBOutlet weak var imeLabel: UILabel!
    @IBOutlet weak var prezimeLabel: UILabel!
    
    @IBOutlet weak var datumLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var telefonLabel: UILabel!
    @IBOutlet weak var adresaLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var zavrsendatumTextField: UITextField!
    
    let datePicker = UIDatePicker()
    var place = [String:String]()
    func createDatePicker(){
        zavrsendatumTextField.textAlignment = .center
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        zavrsendatumTextField.inputAccessoryView = toolbar
        zavrsendatumTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        
        
    }
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        zavrsendatumTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
        
    }
    
    func updatedata(){
        let query = PFQuery(className: "Baranje")
        query.whereKey("objectId", equalTo: sendobjectId)
        query.findObjectsInBackground(block: {(objects,error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            else if let objects = objects {
               let object = objects[0]
                if let datumponuda = object["datumponuda"] as? String {
                    if let place = object["lokacija"] {
                        
                        //print(place)
                       self.place = place as! [String:String]
                        //print(self.place)
                        if let name = self.place["name"] {
                            self.datumLabel.text = object["datumponuda"] as? String
                            print(datumponuda)
                            self.statusLabel.text = object["status"] as? String
                            self.adresaLabel.text = name
                        }
                    }
                    
                
                }
                
            }
            
        })
    
    let userquery = PFUser.query()
    //print("korisnik")
    //print(korisnikIds[indexPath.row])
    userquery?.whereKey("objectId", equalTo: sendkorisnikId)
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
                
                
                
            }
            
        })
    }
    
    @IBAction func lokacijaButtonPressed(_ sender: Any) {
        
    }
    
    
}
