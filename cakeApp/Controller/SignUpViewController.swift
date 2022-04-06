import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var fullnameText: UITextField!
    @IBOutlet weak var mobileText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signUpButtonClicked: UIButton!
    @IBOutlet weak var AlreadyloginButtonClicked: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
               
    }
    
    @IBAction func AlreadyloginButtonClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToLogin", sender: self)
        
    }
    
    func validateFields( ) -> String? {

        // Check that all fields are filled in
        if fullnameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            mobileText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {

            return "Please fill in all fields."

        }

        // Check if the password is secure
        let cleanedPassword = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        if isPasswordValid(cleanedPassword) == false {

            // Password isn't secure enough
            return "Please make sure your password is at least 8 characters, contains a special character and a number."

        }

        return nil
    }


    @IBAction func signUpButtonClicked(_ sender: Any) {

        // Validate the fields
        let error = validateFields( )
    }
    
    func isPasswordValid(_ password : String) -> Bool {

        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with:  password)

    }

}
