import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import AuthenticationServices

class ViewController: UIViewController {

    @IBOutlet weak var sliderCollectionview: UICollectionView!
    @IBOutlet weak var fullnameField: UILabel!

    var imageArray = [
        UIImage(named: "cake31"),
        UIImage(named: "cake3"),
        UIImage(named: "cake5"),
        UIImage(named: "cake7"),
        UIImage(named: "cake9"),
        UIImage(named: "cake11")]
    var timer = Timer()
    var counter = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        let db =  Firestore.firestore()
        let userID = Auth.auth().currentUser?.uid ?? ""

        if Auth.auth().currentUser != nil {

            db.collection("users").document(userID).getDocument() { [self] (querySnapshot, err) in
                if err != nil {
                    print("error getting documents")
                }
                else{
                    print(querySnapshot?.data())
                    let fullnameField = querySnapshot?["fullname"] as? String ?? ""
                    self.fullnameField.text = fullnameField

                }
            }
        }
    }

    @objc func changeImage() {

        if counter < imageArray.count {

            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionview.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            counter += 1
        }
        else {

            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionview.scrollToItem(at: index, at: .centeredHorizontally, animated: true)

        }
    }

    @IBAction func labelButtonClicked(_ sender: Any) {

        self.performSegue(withIdentifier: "goToAdminHome", sender: self)
    }

    @IBAction func nameButtonClicked(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "goToAccount", sender: self)
        }
        else{
            self.performSegue(withIdentifier: "goToLogin", sender: self)
        }
        self.performSegue(withIdentifier: "goToLogin", sender: self)
    }

    @IBAction func accountButtonClicked(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "goToAccount", sender: self)
        }
        else{
            self.performSegue(withIdentifier: "goToLogin", sender: self)
        }
        self.performSegue(withIdentifier: "goToLogin", sender: self)
    }

    @IBAction func premadeButtonClicked(_ sender: Any) {

        self.performSegue(withIdentifier: "goToPremade", sender: self)

    }

    @IBAction func customizeCakeButtonClicked(_ sender: Any) {

        self.performSegue(withIdentifier: "goToCustomizeCake", sender: self)
    }

    @IBAction func cartButtonclicked(_ sender: Any) {

        self.performSegue(withIdentifier: "goToCart", sender: self)
    }

}
