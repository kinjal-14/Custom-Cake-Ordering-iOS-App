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
    
    func validateFields( ) -> String? {

        // Check that all fields are filled in
        if emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {

            return "Please fill in all fields."

        }

        return nil
    }

    
    @IBAction func loginButtonClicked(_ sender: Any) {
   
    
    
    }

}
