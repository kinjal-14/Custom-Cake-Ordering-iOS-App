import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

protocol CartItemDelegate: AnyObject {
    
    func removeItem(cartProduct: CartProduct)
}

class CartItemCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productQty: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var removeProductButton: UIButton!
    var cartItems = [CartProduct]()

    let db =  Firestore.firestore()

    private var item: CartProduct!
    weak var delegate : CartItemDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func configureCell(cartProduct: CartProduct, delegate: CartItemDelegate) {
        
        self.delegate = delegate
        self.item = cartProduct
        
        productName.text = cartProduct.name
        productPrice.text = "Price: $" + String(cartProduct.price)
        productQty.text = "Quantity: " + String(cartProduct.qty)
        productImage.image = UIImage(named: cartProduct.image)
       
    }
    
    @IBAction func removeButtonClicked(_ sender: Any) {
        
        delegate?.removeItem(cartProduct: item)

    }
    
}

