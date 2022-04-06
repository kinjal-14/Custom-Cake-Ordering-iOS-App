import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class PaymentViewController: UIViewController {

    @IBOutlet weak var paymentImage: UIImageView!
    
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
    var order_id = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        paymentImage.layer.cornerRadius = 125
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToShipping", sender: self)
    }
    
    @IBAction func continueButtonClicked(_ sender: Any) {
        
        let db = Firestore.firestore()
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            let uid = (user?.uid)!
//            let uuid = UUID().uuidString
            let docRef = db.collection("user").document(uid).collection("order").document(String(order_id))
            docRef.setData([
                "id": order_id,
                "address1": address1,
                "address2": address2,
                "postalCode": postalCode,
                "city": city,
                "state": state,
                "subtotal": subtotal,
                "cost": cost,
                "tax": tax,
                "total": total,
                "orderType": "Completed"
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }

            showToast(controller: self, message: "Order has been successfully placed", seconds: 1)
            self.performSegue(withIdentifier: "goToHome", sender: self)

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
