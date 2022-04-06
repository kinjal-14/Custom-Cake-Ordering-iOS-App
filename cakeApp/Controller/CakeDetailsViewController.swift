import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class CakeDetailsViewController: UIViewController {

    @IBOutlet weak var imageField: UIImageView!
    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var descField: UILabel!
    @IBOutlet weak var caloriesField: UILabel!
    @IBOutlet weak var sizeField: UILabel!
    @IBOutlet weak var priceField: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    
    let db =  Firestore.firestore()
    var products = [Product]()
    var product = Product(cake_id: "", cake_name: "", cake_price: "", cake_size: "", cake_image: "", cake_desc: "", cake_cal: "")
    
    var cake_id = ""
    var cake_name = ""
    var cake_price = ""
    var cake_size = ""
    var cake_image = ""
    var cake_desc = ""
    var cake_cal = ""
    var count = 1
    var cake_category = "pre-made cake"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let db =  Firestore.firestore()
//        print("-----------********************----------------")
//        print(cake_name)
//        print(cake_image)
//        print(cake_desc)
//        print(cake_price)
//        print(cake_size)
//        print(cake_cal)
        
        nameField.text = cake_name
        imageField.image = UIImage(named: cake_image)
        priceField.text = "Price: $"+String(cake_price)
        descField.text = cake_desc
        caloriesField.text = "Calories: "+String(cake_cal)
        sizeField.text = "Size: "+String(cake_size)
        count = 1
        qtyLabel.text = String(count)

    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToPremade", sender: self)
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
//            let uuid = UUID().uuidString
            let docRef = db.collection("users").document(uid).collection("cart").document(String(cake_id))
            docRef.setData([
                "name": cake_name,
                "image": cake_image,
                "id": cake_id,
                "customType":"",
                "design":"",
                "flavour":"",
                "shape":"",
                "size":cake_size,
                "price":cake_price,
                "qty":count,
                "note":"",
                "type":"Pre-Made Cake"
                
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

