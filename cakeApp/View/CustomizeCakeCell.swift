import UIKit

class CustomizeCakeCell: UICollectionViewCell {

    
    @IBOutlet weak var cakeTypeImage: UIImageView!
    @IBOutlet weak var cakeTypeName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        cakeTypeImage.layer.cornerRadius = 5

    }
    
    func configureCell(customizeCake: CustomizeCake) {
        
        cakeTypeName.text = customizeCake.name
        cakeTypeImage.image = UIImage(named:customizeCake.image)
            
    }
    func getData(customizeCake: CustomizeCake) -> (String){
//        cakeTypeName.text = customizeCake.name
//        cakeTypeImage.image = UIImage(named: customizeCake.image)

        return (customizeCake.name)
        return (customizeCake.image)
    }

}
