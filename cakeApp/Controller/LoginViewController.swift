import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore

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
    
    func validateFields( ) -> String? {

        // Check that all fields are filled in
        if emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {

            return "Please fill in all fields."

        }

        return nil
    }

    
    @IBAction func loginButtonClicked(_ sender: Any) {
   
        // Validate the fields
        let error = validateFields( )

        if error != nil {

            let msg = UIAlertController(title: "Error", message:error, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in print("OK button tapped")})
            msg.addAction(ok)
            self.present(msg, animated: true, completion: nil)
        }
        else {

            let email = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
                if err != nil{
                    // err?.localizedDescription
                    let msg = UIAlertController(title: "Error", message: err?.localizedDescription, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        print("OK BUTTON TAPPED")
                    })
                    msg.addAction(ok)
                        self.present(msg, animated: true, completion: nil)
                }
            
                else{
                                   
                    self.performSegue(withIdentifier: "goToHome", sender: self)
                                    
                }
            }
        }
    
    }

}
