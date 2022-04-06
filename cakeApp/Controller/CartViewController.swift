import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CartItemDelegate {
    
    var subtotal = 0.0
    var tax = 0.0
    var cost = 10.0
    var totalPrice = 0
    var products = [CartProduct]()
    var cake_id = 0
    var cake_name = ""
    var cake_price = ""
    var cake_size = ""
    var cake_image = ""
    var cake_desc = ""
    var cake_cal = ""
    var count = 1
    var cake_category = ""
    var total = 0
    var customType = ""
    var flavour = ""
    var note = ""
    
    let db =  Firestore.firestore()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    var cartProducts = [CartProduct]()
    var cartProduct = CartProduct(name: "", id: "", image: "", desc: "", price: "", qty: 0, type: "", design: "", size: "", shape: "", flavour: "", note: "", customType: "")
    override func viewDidLoad() {
        super.viewDidLoad()

        total = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifiers.CartItemCell, bundle: nil), forCellReuseIdentifier: Identifiers.CartItemCell)
        self.products.removeAll()
        self.fetchProducts()

    }
    
    @IBAction func orderButtonClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToShipping", sender: self)
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToPremade", sender: self)
    }
    
    func removeItem(cartProduct: CartProduct) {

        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            let uid = (user?.uid)!
            let id = cartProduct.id

            let docRemoveRef = db.collection("cart").document(uid).delete() { error in
                if error != nil {
                    print("Removing Document..!")
                }
                else {
                    print("Document successfully removed..!!")
                }
            }
//
//            docRemoveRef.delete { error, _ in
//               print(error ?? "went wrong" as Any)
//            }
            
//            let docRemoveRef = db.collection("cart").document(id)
//
//            docRemoveRef.delete { error, _ in
//               print(error ?? "went wrong" as Any)
//            }
        }
    }
   

//            docRemoveRef.delete { error, _ in
//                print(error ?? "went wrong" as Any)
//
//            }
//            docRemoveRef.removeValue { error, _ in
//
//                print(error ?? "went wrong" as Any)
//            }
        
//
//        func removeItem(product: CartProduct) {
//
//            if Auth.auth().currentUser != nil {
//            let userID = Auth.auth().currentUser?.uid
//            let collectionReference = ref?.child("cart").child(userID!).child(String(product.id))
//                  collectionReference!.removeValue { error, _ in
//
//                      print(error ?? "went wrong" as Any)
//                  }}
//        }
//        CartItemCell.removeItemFromCart(item: cartProduct)
//        tableView.reloadData()
    

    func fetchProducts() {

        let db =  Firestore.firestore()
        total = 0
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            let uid = (user?.uid)!
//            let uuid = UUID().uuidString
            let docRef = db.collection("users").document(uid).collection("cart").getDocuments() { [self] (querySnapshot, err) in
                if err != nil {
                    print("Error getting documents")
                }
                else {
                    for document in querySnapshot!.documents {
                        let values = document.data() as? NSDictionary
                        let name = values?["name"] as? String ?? ""
                        let id = values?["id"] as? String ?? ""
                        let size = values?["size"] as? String ?? ""
                        let price = values?["price"] as? String ?? ""
                        let image = values?["image"] as? String ?? ""
                        let desc = values?["desc"] as? String ?? ""
                        let type = values?["type"] as? String ?? ""
                        let design = values?["design"] as? String ?? ""
                        let qty = values?["qty"] as? Int ?? 0
                        let shape = values?["shape"] as? String ?? ""
                        let flavour = values?["flavour"] as? String ?? ""
                        let note = values?["note"] as? String ?? ""
                        let customType = values?["customType"] as? String ?? ""
                        
                        self.totalPrice = Int(price)! * qty
                        self.subtotal = subtotal + Double(totalPrice)
                        self.total = total + Int(subtotal)

                        let newCartProduct = CartProduct.init(name: name, id: id, image: image, desc: desc, price: price, qty: qty, type: type, design: design, size: size, shape: shape, flavour: flavour, note: note, customType: customType)
                        self.cartProducts.append(newCartProduct)
    
                }
                self.tableView.reloadData()
                    subtotalLabel.text = "$" + String(subtotal)
                    deliveryLabel.text = "$" + String(cost)
                    tax = subtotal * 0.15
                    taxLabel.text = "$" + String(Int(tax))
                    total = Int(tax + cost + subtotal)
                    totalLabel.text = "$" + String(total)

                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return cartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.CartItemCell, for: indexPath) as? CartItemCell {
            
            cell.configureCell(cartProduct: cartProducts[indexPath.item], delegate: self)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToShipping"{
            if segue.destination is ShippingViewController {
            let vc = segue.destination as? ShippingViewController

                vc?.cartProducts = cartProducts
                vc?.subtotal = Int(subtotal)
                vc?.cost = Int(cost)
                vc?.tax = Int(tax)
                vc?.total = total
            }
        }
    }
    
}

