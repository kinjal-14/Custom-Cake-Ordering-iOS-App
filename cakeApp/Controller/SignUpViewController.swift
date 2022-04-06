import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

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

        if fullnameText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            mobileText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordText.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {

            return "Please fill in all fields."
        }

        let cleanedPassword = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        if isPasswordValid(cleanedPassword) == false {

            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        return nil
    }

    @IBAction func signUpButtonClicked(_ sender: Any) {

        let error = validateFields( )
        if error != nil {

            let msg = UIAlertController(title: "Error", message:error, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in print("OK button tapped")})
            msg.addAction(ok)
            self.present(msg, animated: true, completion: nil)
        }
        else {

            let fullname = fullnameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let mobile = mobileText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            Auth.auth().createUser(withEmail: email, password: password) { authResult, err in
                if err != nil {

                    let msg = UIAlertController(title: "Error", message:err?.localizedDescription, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in print("OK button tapped")})
                    msg.addAction(ok)
                    self.present(msg, animated: true, completion: nil)
                }
                else{
                    let db = Firestore.firestore()
                    db.collection("users").document(authResult!.user.uid).setData( ["fullname":fullname,"mobile":mobile,"email":email,"password":password,"uid":authResult!.user.uid]){
                        (err) in
                        if err != nil {

                            let msg = UIAlertController(title: "Error", message:err?.localizedDescription, preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in print("OK button tapped")})
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
    }

    func isPasswordValid(_ password : String) -> Bool {

        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with:  password)

    }
    
}
