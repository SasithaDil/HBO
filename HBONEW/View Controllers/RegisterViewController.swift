//
//  RegisterViewController.swift
//  HBONEW
//
//  Created by Sasitha Dilshan on 1/29/20.
//  Copyright © 2020 Sasitha Dilshan. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class RegisterViewController: UIViewController {
    

    @IBOutlet weak var FnameText: UITextField!
    @IBOutlet weak var LnameText: UITextField!
    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var PasswordText: UITextField!
    @IBOutlet weak var ConfirmPasswordText: UITextField!
    @IBOutlet weak var ZipCodeText: UITextField!
    @IBOutlet weak var RegisterButton: UIButton!
    @IBOutlet weak var ErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        navigationController?.navigationBar.barTintColor = UIColor.black
        setUpEmements()

    }
    
    func setUpEmements(){
        ErrorLabel.alpha = 0
    }
    func validateFields() -> String?{
        
        if FnameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            LnameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            EmailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            PasswordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            ConfirmPasswordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "Fill in all fields."
        }
        
        let cleanPassword = PasswordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanPassword) == false {
            return"please make sure your passwoed is atleast 8 characters, containd a special characters and a number"
        }
        
        return nil
    }

    @IBAction func RegisterTapped(_ sender: Any) {
        let error = validateFields()
        if error != nil {
            showError(error!)
        }
        else{
            
            let firstName = FnameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = LnameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = EmailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = PasswordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                if err != nil{
                    self.showError("Error creating user.")
                }
                else{
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["FirstName" : firstName, "LastName": lastName, "email": email, "uid":  result!.user.uid]) { (error) in
                        
                        if  error != nil{
                            self.showError("Error saving user data")
                        }
                    }
                    self.transitionToHome()
                }
            }
        }
        
    }
    
    func showError(_ message:String){
        
        ErrorLabel.text = message
        ErrorLabel.alpha = 1
    }
    
    func transitionToHome(){
        
        let homeViewController =  storyboard?.instantiateViewController(withIdentifier: Constants.StoryBoard.homeViewController) as? homeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
}
