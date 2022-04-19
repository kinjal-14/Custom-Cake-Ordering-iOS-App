import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class CustomizeInfoViewController: UIViewController {

    @IBOutlet weak var typeField: UILabel!
    @IBOutlet weak var shapeField: UILabel!
    @IBOutlet weak var designField: UILabel!
    @IBOutlet weak var flavourField: UILabel!
    @IBOutlet weak var sizeField: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    
    @IBOutlet weak var noteField: UITextField!
    
    var type = ""
    var shape = ""
    var size = ""
    var design = ""
    var flavour = ""
    var note = ""
    var count = 1

    
    override func viewDidLoad() {
        super.viewDidLoad()

        typeField.text = self.type
        shapeField.text = self.shape
        sizeField.text = self.size
        flavourField.text = self.flavour
        designField.text = self.design
        noteField.text = self.note
    }

    @IBAction func homeButtonClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    @IBAction func cartButtonClicked(_ sender: Any) {
    
        self.performSegue(withIdentifier: "goToCart", sender: self)
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToCustomizeCake", sender: self)
    }

    
    @IBAction func minusButtonClicked(_ sender: Any) {
        
        if(count <= 1){
            count = 1
            qtyLabel.text = String(count)
        }
        else{
            count -= 1
            qtyLabel.text = String(count)
        }
    }
    
    @IBAction func plusButtonClicked(_ sender: Any) {
        
        if(count >= 20){
            count = 20
            qtyLabel.text = String(count)
        }
        else{
            count += 1
            qtyLabel.text = String(count)
        }
    }
   
    @IBAction func addToCartButtonClicked(_ sender: Any) {
        
        let db = Firestore.firestore()
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            let uid = (user?.uid)!
            let uuid = UUID().uuidString
            let docRef = db.collection("users").document(uid).collection("cart").document(String(uuid))
            docRef.setData([
                "name": "Customize Cake",
                "image": "cake_peanut",
                "id": uuid,
                "customType":type,
                "design":design,
                "flavour": flavour,
                "shape": shape,
                "size":size,
                "price":"100",
                "qty":count,
                "note": note,
                "type":"Customize Cake"
                
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }

            showToast(controller: self, message: "Added to the cart", seconds: 1)
        }
    }
    
    func showToast(controller: UIViewController, message: String, seconds: Double){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds){
            alert.dismiss(animated: true)
        }
    }
}

