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
    var uuid = ""
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

        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: addCardViewController)
//        performsActionsWhilePresentingModally(navigationController, animated: true)
        present(navigationController, animated: true)
//        present(navigationController, animated: true)
        
//        print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
//        print(cartProducts)
//        print(subtotal)
//        print(total)
//        print(cost)
//        print(tax)
//        print(address1)
//        print(address2)
//        print(postalCode)
//        print(city)
//        print(state)
//        self.performSegue(withIdentifier: "goToPayment", sender: self)
        
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
                uuid = UUID().uuidString
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
                        db.collection("users").document(String(uid)).collection("cart").document(String(cartProduct.id)).delete() { err in
                            if let err = err {
                                print("Error removing document: \(err)")
                            } else {
                                print("Document successfully removed!")
                            }
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

                showToast(controller: self, message: "Order has been successfully placed", seconds: 1)
//                self.performSegue(withIdentifier: "goToPayment", sender: self)
            }
        }
    }
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
    
        dismiss(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        
        dismiss(animated: true)
        
        print("Printing Strip Token:\(token.tokenId)")
        
        showToast(controller: self, message: "Transaction Success: \n Here is the Token Id: \(token.tokenId)", seconds: 1)

    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreatePaymentMethod paymentMethod: STPPaymentMethod, completion: @escaping STPErrorBlock) {
        
        dismiss(animated: true)
        
//
//        print("Printing Strip Token:\(token.tokenId)")
//
//        showToast(controller: self, message: "Transaction Success: \n Here is the Token Id: \(token.tokenId)", seconds: 1)
        
//        showToast(controller: self, message: "Order has been placed successfully..", seconds: 1)
        
        let msg = UIAlertController(title: "Success", message: "Order has been placed successfully..", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            let userID = Auth.auth().currentUser?.uid
                            let email = Auth.auth().currentUser?.email
            let text = "Order id: #" + self.uuid + "\nHello,your order has been placed successfully. It will be delivered in 2-3 buisness days.Thank you keep shopping"
                           
            self.sendEmail(text: text,email: email!,id: self.uuid)
                    self.performSegue(withIdentifier: "goToHome", sender: self)
        })
        msg.addAction(ok)
        self.present(msg, animated: true, completion: nil)
//        self.performSegue(withIdentifier: "goToHome", sender: self)
        
    }
    func sendEmail(text: String,email: String,id: String) {

                let smtpSession = MCOSMTPSession()
                smtpSession.hostname = "smtp.gmail.com"
                smtpSession.username = "priyagondaliya444@gmail.com"
                smtpSession.password = "Gondaliya444@"
                smtpSession.port = 465

                smtpSession.connectionType = MCOConnectionType.TLS
                smtpSession.connectionLogger = {(connectionID, type, data) in
                    if data != nil {
                        if let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                            NSLog("Connectionlogger: \(string)")
                           
                        }
                    }
                }
                let builder = MCOMessageBuilder()
                builder.header.to = [MCOAddress(displayName: "Cake Dreams", mailbox: email)]
                builder.header.from = MCOAddress(displayName: "Cake Dreams", mailbox: "priyagondaliya444@gmail.com")
                builder.header.subject = "Order Success"
                builder.htmlBody="<p>" + text + "</p>"


                let rfc822Data = builder.data()
                let sendOperation = smtpSession.sendOperation(with: rfc822Data)
                sendOperation?.start { (error) -> Void in
                    if (error != nil) {
                        NSLog("Error sending email: \(error)")
                      


                    } else {
                        NSLog("Successfully sent email!")
                       
                    }
                }
            }
        func showMailError(){
            let sendMailErrorAlert = UIAlertController(title: "could not send mail", message: "could not send", preferredStyle: .alert)
            let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
            sendMailErrorAlert.addAction(dismiss)
            self.present(sendMailErrorAlert,animated: true, completion: nil)
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
