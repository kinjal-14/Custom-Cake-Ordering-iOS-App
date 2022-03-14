import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var fullnameText: UITextField!
    
    @IBOutlet weak var mobileText: UITextField!
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var signUpButtonClicked: UIButton!
    
    @IBOutlet weak var AlreadyloginButtonClicked: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements( )
        // Do any additional setup after loading the view.
    }
    
    @IBAction func AlreadyloginButtonClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToLogin", sender: self)
        
    }
    

    @IBAction func signUpButtonClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToHome", sender: self)

    }
    
    func setUpElements( ) {
        
        Utilities.styleTextField(fullnameText)
        
        Utilities.styleTextField(mobileText)
        
        Utilities.styleTextField(emailText)
        
        Utilities.styleTextField(passwordText)
        
        Utilities.styleFilledButton(signUpButtonClicked)
        
        Utilities.styleFilledButton(AlreadyloginButtonClicked)
        
    }
    
    
}
