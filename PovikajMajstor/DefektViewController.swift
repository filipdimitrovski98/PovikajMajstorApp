//
//  DefektViewController.swift
//  PovikajMajstor
//
//  Created by Filip Dimitrovski on 1/4/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit
import Parse
import MapKit
import CoreLocation

var globalplace = [String:String]()
var globalprofesija = String()
var globalopis = String()
class DefektViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate{
    var manager = CLLocationManager()
    let profesii = ["Elektricar","Vodovodzija","Parketar","Moler"]
    var profesija = "Elektricar"
    var pressed = false

    override func viewDidLoad() {
        super.viewDidLoad()
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(DefektViewController.longpress(gestureRecognizer:)))
        uilpgr.minimumPressDuration = 2
        map.addGestureRecognizer(uilpgr)
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
               
    }
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var profesijaPickerView: UIPickerView!
    
    @IBOutlet weak var opisTextField: UITextField!
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return profesii.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return profesii[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        profesija = profesii[row]
        globalprofesija = profesija
        print(profesija)
    }
    
    
    
    
    @IBAction func logoutPressed(_ sender: Any) {
        PFUser.logOut()
        print("Logout Success")
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func pokaziMajstoriPressed(_ sender: Any) {
        if pressed == false {
            displayAlert(title: "Error in form", message: "Postavi lokacija na defektot")
            
        }
        else{
        if let opis = opisTextField.text {
            globalopis = opis
        }
        else {
            
            globalopis = "Defektot nema opis"
        }
        
        performSegue(withIdentifier: "toMajstori", sender: nil)
        }
    }
    @objc func longpress(gestureRecognizer: UIGestureRecognizer) {
        print("longpress")
        if(self.pressed) {
            print("Already pressed")
            return
            
        }
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = gestureRecognizer.location(in: self.map)
            let newCoordinate = self.map.convert(touchPoint, toCoordinateFrom: self.map)
            let newLocation = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            //print(newCoordinate)
            var title = ""
            CLGeocoder().reverseGeocodeLocation(newLocation, completionHandler: { (placemarks, error) in
                if error != nil {
                    print(error!)
                }
                else {
                    if let placemark = placemarks?[0] {
                        if placemark.subThoroughfare != nil {
                            title += placemark.subThoroughfare! + " "
                        }
                        if placemark.thoroughfare != nil {
                            title += placemark.thoroughfare!
                        }
                    }
                    if title == "" {
                        title = "Added \(NSDate())"
                    }
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = newCoordinate
                    annotation.title = title
                    self.map.addAnnotation(annotation)
                    let lat = String(newCoordinate.latitude)
                    let lon = String(newCoordinate.longitude)
                    
                    let place = ["name": title,
                    "lat": lat,
                    "lon": lon
                    ]
                   
                   
                    globalplace = place
                    print(globalplace)
                    self.pressed = true
                    }
            })
            /*let annotation = MKPointAnnotation()
             annotation.coordinate = newCoordinate
             annotation.title = "Temp"
             self.map.addAnnotation(annotation)*/
        }
    }
    
    @IBAction func baranjaButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "tokorisnikbaranja", sender: nil)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        self.map.setRegion(region, animated: true)
    }
    func displayAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
}

