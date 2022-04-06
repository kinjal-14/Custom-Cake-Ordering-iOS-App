import UIKit
import FirebaseAuth
import FirebaseFirestore

class AccountViewController: UIViewController {

    @IBOutlet weak var accountImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        accountImage.layer.cornerRadius = 125
    }
    
    @IBAction func orderButtonClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToDeliveredOrder", sender: self)
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {

        self.performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    
    @IBAction func contactUsButtonClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToContact", sender: self)
    }
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
                   
            self.performSegue(withIdentifier: "goToHome", sender: self)
        }
        catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

