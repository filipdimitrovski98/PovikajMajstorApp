//
//  MajstorRabotaDetailViewController.swift
//  PovikajMajstor
//
//  Created by Filip Dimitrovski on 1/10/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit
import Parse

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

class MajstorRabotaDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
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
    @IBOutlet weak var imageToPost: UIImageView!
    @IBOutlet weak var zavrsendatumTextField: UITextField!
    
    @IBOutlet weak var postimageButton: UIButton!
    @IBOutlet weak var chooseimageButton: UIButton!
    @IBOutlet weak var zavrsenoButton: UIButton!
    
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
    
    @IBAction func zavrsiPressed(_ sender: Any) {
        let query = PFQuery(className:"Baranje")
        query.getObjectInBackground(withId: sendobjectId) { (baranje: PFObject?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let baranje = baranje {
                baranje["status"] = "zavrsenarabota"
                baranje["datumzavrsuvanje"] = self.zavrsendatumTextField.text
                baranje.saveInBackground()
                print("Uspesno zavrsena rabota")
            }
        }
        
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
                
                    if let place = object["lokacija"] {
                        
                        //print(place)
                        self.place = place as! [String:String]
                        //print(self.place)
                        if let name = self.place["name"] {
                            self.statusLabel.text = object["status"] as? String
                            self.datumLabel.text = object["datumponuda"] as? String
                            
                            
                            if self.statusLabel.text == "zavrsenarabota" as String {
                                self.zavrsendatumTextField.text = object["datumzavrsuvanje"] as? String
                                self.zavrsendatumTextField.isEnabled = false
                                self.postimageButton.isHidden = true
                                self.chooseimageButton.isHidden = true
                                self.zavrsenoButton.isHidden = true
                                let imageFile = object["imageFile"] as! PFFileObject
                                
                                imageFile.getDataInBackground { (data, error) in
                                    if let imageData = data {
                                        if let imageToDisplay = UIImage(data: imageData) {
                                            self.imageToPost.image = imageToDisplay
                                        }
                                    }
                                }
                                
                                
                            }
                            
                             
                             self.adresaLabel.text = name
                        
                            
                            
                           
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
    
    @IBAction func chooseImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageToPost.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func locationPressed(_ sender: Any) {
        
        
    }
    
    @IBAction func postImage(_ sender: Any) {
        
        if let image = imageToPost.image {
                  let query = PFQuery(className:"Baranje")
                  query.getObjectInBackground(withId: sendobjectId) { (baranje: PFObject?, error: Error?) in
                      if let error = error {
                          print(error.localizedDescription)
                      } else if let baranje = baranje {
                          
                        if let imageData = image.jpeg(.medium) {
                            let imageFile = PFFileObject(name: "image.jpg", data: imageData)
                            baranje["imageFile"] = imageFile
                            
                         let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                            activityIndicator.center = self.view.center
                            activityIndicator.hidesWhenStopped = true
                            activityIndicator.style = UIActivityIndicatorView.Style.medium
                            self.view.addSubview(activityIndicator)
                            
                            UIApplication.shared.beginIgnoringInteractionEvents()
                            
                            baranje.saveInBackground { (success, error) in
                                activityIndicator.stopAnimating()
                                UIApplication.shared.endIgnoringInteractionEvents()
                                
                                if success {
                                    self.displayAlert(title: "Image posted!", message: "Your image hase been posted succesfully")
                                    
                                    
                                } else {
                                    self.displayAlert(title: "Image could not be posted", message: error?.localizedDescription ?? "Please try again later")
                                }
                            }
                        }
                          
                          
                      }
                  }
                   
            
               }

 }
    func displayAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
}
