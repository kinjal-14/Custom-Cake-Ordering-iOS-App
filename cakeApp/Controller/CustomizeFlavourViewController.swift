import UIKit

class CustomizeFlavorViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var name = ""
    var image = ""
    var flavour = "Almond"
    var customizeCake = [CustomizeCake]()
    var type = ""
    var shape = ""
    var size = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()

        let customizeCake1 = CustomizeCake.init(name: "Almond", image: "cake_almond")
        let customizeCake2 = CustomizeCake.init(name: "Strawberry", image: "cake_strawberry")
        let customizeCake3 = CustomizeCake.init(name: "Banana", image: "cake_lemon")
        let customizeCake4 = CustomizeCake.init(name: "Chocolate", image: "cake_choco")

        customizeCake.append(customizeCake1)
        customizeCake.append(customizeCake2)
        customizeCake.append(customizeCake3)
        customizeCake.append(customizeCake4)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Identifiers.CustomizeCakeCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.CustomizeCakeCell)
    }
    
    @IBAction func homeButtonClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    
    @IBAction func continueButtonClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToCustomizeDesign", sender: self)
    }
    
    @IBAction func cartButtonClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToCart", sender: self)
    }
    
}

extension CustomizeFlavorViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) ->
        Int {
        
            return customizeCake.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CustomizeCakeCell, for: indexPath) as? CustomizeCakeCell {
            
            cell.configureCell(customizeCake: customizeCake[indexPath.item])
            return cell
        }
        return UICollectionViewCell()

    }
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath){
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CustomizeCakeCell, for: indexPath) as! CustomizeCakeCell

        if(indexPath.item == 0){
            flavour = "Almond"
        }
        if(indexPath.item == 1){
            flavour = "Strawberry"
        }
        if(indexPath.item == 2){
            flavour = "Banana"
        }
        if(indexPath.item == 3){
            flavour = "Chocolate"
        }
        let msg = UIAlertController(title: "Selected flavour", message: flavour, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
//            print("OK BUTTON TAPPED")
        })
        msg.addAction(ok)
        self.present(msg, animated: true, completion: nil)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCustomizeDesign"{
            if segue.destination is CustomizeDesignViewController {
            let vc = segue.destination as? CustomizeDesignViewController
             
                vc?.type = type
                vc?.shape = shape
                vc?.size = size
                vc?.flavour = flavour

            }
        }
      
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        let cellWidth = (width - 50) / 2
        let cellHeight = cellWidth * 1.2
        
        return CGSize(width: cellWidth, height: cellHeight)
    }

}

