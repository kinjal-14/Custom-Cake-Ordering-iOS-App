import UIKit
import FirebaseFirestore
import FirebaseAuth

class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productSize: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        productImage.layer.cornerRadius = 5
    }

    func configureCell(product: Product) {
        
        productName.text = product.cake_name
        productPrice.text = "$" + String(product.cake_price)
        productSize.text = " | Size: " + String(product.cake_size)
        productImage.image = UIImage(named:product.cake_image)
            
    }
    func getData(product: Product) -> (String,String,String,String,String,String,String){

        return (product.cake_name ?? "", product.cake_desc ?? "", product.cake_cal ?? "", product.cake_price ?? "",product.cake_size ?? "",product.cake_image ?? "",product.cake_id)

    }
}

