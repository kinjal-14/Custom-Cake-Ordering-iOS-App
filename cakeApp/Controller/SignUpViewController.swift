import UIKit

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func AlreadyloginButtonClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToLogin", sender: self)
        
    }
    

}
