//
//  MajstorBaranjeDetailViewController.swift
//  PovikajMajstor
//
//  Created by Filip Dimitrovski on 1/8/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit
import Parse
import MapKit

class MajstorBaranjeDetailViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        updatedata()
      
        //print(self.place)

        
    }
    let datePicker = UIDatePicker()
    var place = [String:String]()
    
    @IBOutlet weak var imeLabel: UILabel!
    @IBOutlet weak var prezimeLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var opisLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var cenaTextField: UITextField!
    
    @IBOutlet weak var ponudendatumTextField: UITextField!
    
    func createDatePicker(){
        ponudendatumTextField.textAlignment = .center
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        ponudendatumTextField.inputAccessoryView = toolbar
        ponudendatumTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        
        
    }
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        ponudendatumTextField.text = formatter.string(from: datePicker.date)
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
                if let opis = object["opis"] as? String {
                    if let place = object["lokacija"] {
                       self.opisLabel.text = opis
                        //print(place)
                       self.place = place as! [String:String]
                        //print(self.place)
                        if let name = self.place["name"] {
                            if let lat = self.place["lat"] {
                                if let lon = self.place["lon"] {
                                   if let latitude = Double(lat) {
                                       if let longitude = Double(lon) {
                                           let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                           let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                           let region = MKCoordinateRegion(center: coordinate, span: span)
                                           self.map.setRegion(region, animated: true)
                                           let annotation = MKPointAnnotation()
                                           annotation.coordinate = coordinate
                                           annotation.title = name
                                           self.map.addAnnotation(annotation)
                                        self.view.setNeedsDisplay()
                                    }
                                   }
                               }
                           }
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
                self.phoneLabel.text = user["phoneNumber"] as? String
                
                
                
            }
            
        })
    }
    
    
    
    @IBAction func ispratiPonuda(_ sender: Any) {
        if ponudendatumTextField.text == "" || cenaTextField.text == "" {
            displayAlert(title: "Insert both:", message: "Cena and Datum")
        }
        else{
        let query = PFQuery(className:"Baranje")
        query.getObjectInBackground(withId: sendobjectId) { (baranje: PFObject?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let baranje = baranje {
                baranje["status"] = "ispratenaponuda"
                baranje["datumponuda"] = self.ponudendatumTextField.text
                baranje["cena"] = self.cenaTextField.text
                baranje.saveInBackground()
                print("Ponuda uspesno ispratena")
            }
        }
    }
    }
    func displayAlert(title:String, message:String) {
           let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
           alertController.addAction(UIAlertAction(title: "OK", style: .default))
           self.present(alertController, animated: true, completion: nil)
       }
    
    @IBAction func odbijBaranje(_ sender: Any) {
        let query = PFQuery(className:"Baranje")
            print(sendobjectId)
               query.getObjectInBackground(withId: sendobjectId) { (baranje: PFObject?, error: Error?) in
                   if let error = error {
                       print(error.localizedDescription)
                   } else if let baranje = baranje {
                      
                    baranje.deleteInBackground()
                    print("Ponuda uspesno odbiena")
                   }
               }
    }
}
