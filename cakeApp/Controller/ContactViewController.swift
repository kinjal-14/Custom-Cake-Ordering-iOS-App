import UIKit

class ContactViewController: UIViewController {

    @IBOutlet weak var contactImage: UIImageView!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        contactImage.layer.cornerRadius = 55

    }
  
    @IBAction func backButtonClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToAccount", sender: self)
    }
}
