import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import Stripe

class ShippingViewController: UIViewController, STPAddCardViewControllerDelegate {
   
    
    @IBOutlet weak var address1Field: UITextField!
    @IBOutlet weak var address2Field: UITextField!
    @IBOutlet weak var postalCodeField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    
    var cartProducts = [CartProduct]()
    var subtotal = 0
    var cost = 0
    var tax = 0
    var total = 0
    var address1 = ""
    var address2 = ""
    var postalCode = ""
    var city = ""
    var state = ""
    
    @IBOutlet weak var shippingImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        print("********************************************************")
//        print(cartProducts)
//        print(subtotal)
//        print(total)
//        print(cost)
//        print(tax)
        shippingImage.layer.cornerRadius = 125
        
    }
    
    func validateFields( ) -> String? {

        // Check that all fields are filled in
        if address1Field.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            address2Field.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            postalCodeField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            cityField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            stateField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {

            return "Please fill in all fields."

        }
        return nil
    }

    @IBAction func backButtonClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToCart", sender: self)
    }
    
    @IBAction func buyButtonClicked(_ sender: Any) {

        let error = validateFields( )

        if error != nil {

            let msg = UIAlertController(title: "Error", message:error, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in print("OK button tapped")})
            msg.addAction(ok)
            self.present(msg, animated: true, completion: nil)
        }
        else {
            address1 = address1Field.text ?? ""
            address2 = address2Field.text ?? ""
            postalCode = postalCodeField.text ?? ""
            city = cityField.text ?? ""
            state = stateField.text ?? ""
            let db = Firestore.firestore()
            if Auth.auth().currentUser != nil {
                let user = Auth.auth().currentUser
                let uid = (user?.uid)!
                let uuid = UUID().uuidString
                let docRef = db.collection("users").document(uid).collection("order").document(uuid)
          
                for cartProduct in cartProducts{
                    print(cartProduct.id)
                    let id = cartProduct.id
                    let docProductRef = db.collection("users").document(uid).collection("order").document(uuid).collection("products").document("\(id)")
                    
                    docProductRef.setData([
                        "customType": cartProduct.customType,
                        "design": cartProduct.design,
                        "flavour": cartProduct.flavour,
                        "id": cartProduct.id,
                        "image": cartProduct.image,
                        "name": cartProduct.name,
                        "note": cartProduct.note,
                        "price": cartProduct.price,
                        "qty": cartProduct.qty,
                        "shape": cartProduct.shape,
                        "size": cartProduct.size,
                        "type": cartProduct.type

                    ]) { err in
                    if let err = err {

                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
            }

               docRef.setData([
                   "address1": address1,
                  "address2": address2,
                   "city": city,
                 "delivery":cost,
                  "id":uuid,
                    "orderType":"new",
                    "postalCode":postalCode,
                    "state":state,
                    "subtotal":subtotal,
                   "tax":tax,
                    "total":total,


                ]) { err in
                    if let err = err {
                       print("Error writing document: \(err)")
                    } else {
                       print("Document successfully written!")
                        
                    }
                }

//                showToast(controller: self, message: "Order has been successfully placed", seconds: 1)
                self.performSegue(withIdentifier: "goToPayment", sender: self)
            }
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPayment"{
            if segue.destination is PaymentViewController {
            let vc = segue.destination as? PaymentViewController

                vc?.cartProducts = cartProducts
                vc?.subtotal = Int(subtotal)
                vc?.cost = Int(cost)
                vc?.tax = Int(tax)
                vc?.total = total
                vc?.address1 = address1
                vc?.address2 = address2
                vc?.postalCode = postalCode
                vc?.state = state
                vc?.city = city
            }
        }
    }
    
}
