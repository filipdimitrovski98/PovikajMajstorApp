//
//  ViewController.swift
//  PovikajMajstor
//
//  Created by Filip Dimitrovski on 1/3/21.
//  Copyright © 2021 Filip Dimitrovski. All rights reserved.
//

import UIKit
import Parse



class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
       profesijaPickerView.isHidden = true
       korisnikSwitch.isHidden = true
       korisnikLabel.isHidden = true
       majstorLabel.isHidden = true
        nameTextField.isHidden = true
        lastnameTextField.isHidden = true
        numberTextField.isHidden = true
        
    }
    var signUpMode = false
    let profesii = ["Elektricar","Vodovodzija","Parketar","Moler"]
    var profesija = "Elektricar"
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var login_signupButton: UIButton!
    @IBOutlet weak var switchLoginSignupButton: UIButton!
    @IBOutlet weak var korisnikSwitch: UISwitch!
    @IBOutlet weak var korisnikLabel: UILabel!
    @IBOutlet weak var majstorLabel: UILabel!
    
    @IBOutlet weak var profesijaPickerView: UIPickerView!
    
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
    }
    
    @IBAction func LogIn_SignUp(_ sender: Any) {
       
                   if signUpMode {
                    let user = PFUser()
                    if(korisnikSwitch.isOn){//majstor
                        if emailTextField.text == "" || passwordTextField.text == "" || nameTextField.text == "" || lastnameTextField.text == "" || numberTextField.text == ""{
                            displayAlert(title: "Error in form", message: "You must provide all the informations") }
                        else{
                        
                       user.email = emailTextField.text
                       user.username = emailTextField.text
                       user.password = passwordTextField.text
                       user.email = emailTextField.text
                       user["name"] = nameTextField.text
                       user["lastName"] = lastnameTextField.text
                       user["phoneNumber"] = numberTextField.text
                       user["profesija"] = profesija
                       user["korisnik"] = "majstor"
                       
                       user.signUpInBackground { (success, error) in
                            
                         if let error = error {
                                let errorString = error.localizedDescription
                                self.displayAlert(title: "Error signing up", message: errorString)
                            } else {
                                print("Sign up success!")
                                self.performSegue(withIdentifier: " ", sender: self)
                            }
                        }
                        }
                    }
                    else{ //korisnik
                        if emailTextField.text == "" || passwordTextField.text == "" || nameTextField.text == "" || lastnameTextField.text == "" || numberTextField.text == ""{
                        displayAlert(title: "Error in form", message: "You must provide all the informations") }
                        else {
                        user.email = emailTextField.text
                        user.username = emailTextField.text
                        user.password = passwordTextField.text
                        user.email = emailTextField.text
                        user["name"] = nameTextField.text
                        user["lastName"] = lastnameTextField.text
                        user["phoneNumber"] = numberTextField.text
                        user["korisnik"] = "obicen"
                        
                    user.signUpInBackground { (success, error) in
                        
                     if let error = error {
                            let errorString = error.localizedDescription
                            self.displayAlert(title: "Error signing up", message: errorString)
                        } else {
                            print("Sign up success!")
                            self.performSegue(withIdentifier: "toDefektView", sender: self)
                        }
                    }
                    }
                    }
                   } // signup
               else { //login
                    
                   PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                           
                           if let error = error {
                               let errorString = error.localizedDescription
                               self.displayAlert(title: "Error logging in", message: errorString)
                           } else {
                               print("Log in success!")
                            if(user!["korisnik"] as! String == "obicen"){
                              self.performSegue(withIdentifier: "toDefektView", sender: self)
                            }
                            else if(user!["korisnik"] as! String == "majstor") {
                              self.performSegue(withIdentifier: " ", sender: self) // TUKA SMENI
                            }
                               
                           }
                       }
                       
                   }
    }
    
    @IBAction func Switch_Screens(_ sender: Any) {
        if signUpMode {//smeni vo login
                   signUpMode = false
            profesijaPickerView.isHidden = true
            korisnikSwitch.isHidden = true
            korisnikLabel.isHidden = true
            majstorLabel.isHidden = true
            nameTextField.isHidden = true
            lastnameTextField.isHidden = true
            numberTextField.isHidden = true
            
            
            welcomeLabel.text = "Please Log In"
                   login_signupButton.setTitle("Log In", for: .normal)
                   switchLoginSignupButton.setTitle("Switch to Sign Up", for: .normal)
                
            
               } else {//smeni vo signup
                   signUpMode = true
            profesijaPickerView.isHidden = false
            korisnikSwitch.isHidden = false
            korisnikLabel.isHidden = false
            majstorLabel.isHidden = false
            nameTextField.isHidden = false
            lastnameTextField.isHidden = false
            numberTextField.isHidden = false
            
            welcomeLabel.text = "Please Sign Up"
                    
                   login_signupButton.setTitle("Sign Up", for: .normal)
                   switchLoginSignupButton.setTitle("Switch to Log In", for: .normal)
               }
        
    }
    
    @IBAction func switchPressed(_ sender: Any) {
        if korisnikSwitch.isOn {
            profesijaPickerView.isHidden = false
        }
        else {
            profesijaPickerView.isHidden = true
        }
    }
    
    func displayAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }
}

