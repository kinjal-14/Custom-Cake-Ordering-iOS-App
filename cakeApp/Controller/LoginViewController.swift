//
//  LoginViewController.swift
//  cakeApp
//
//  Created by on 2022-03-11.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signUpButtonClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToSignUp", sender: self)
        
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
   
        self.performSegue(withIdentifier: "goToHome", sender: self)
        
    }
    
    

}
