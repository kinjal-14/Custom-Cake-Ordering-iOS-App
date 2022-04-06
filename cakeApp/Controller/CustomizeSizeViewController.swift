import UIKit

class CustomizeSizeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var name = ""
    var image = ""
    var customizeCake = [CustomizeCake]()
    var size = "0.5"
    var shape = ""
    var type = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let customizeCake1 = CustomizeCake.init(name: "0.5 lbs", image: "cake_size1")
        let customizeCake2 = CustomizeCake.init(name: "1 lb", image: "cake_size2")
        let customizeCake3 = CustomizeCake.init(name: "1.5 lbs", image: "cake_size3")
        let customizeCake4 = CustomizeCake.init(name: "2 lbs", image: "cake_size4")

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
        
        self.performSegue(withIdentifier: "goToCustomizeFlavor", sender: self)
    }
    
    @IBAction func cartButtonClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToCart", sender: self)
    }
    
}

extension CustomizeSizeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
            size = "0.5"
        }
        if(indexPath.item == 1){
            size = "1"
        }
        if(indexPath.item == 2){
            size = "1.5"
        }
        if(indexPath.item == 3){
            size = "2"
        }
        let msg = UIAlertController(title: "Selected size", message: size, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
//            print("OK BUTTON TAPPED")
        })
        msg.addAction(ok)
        self.present(msg, animated: true, completion: nil)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCustomizeFlavor"{
            if segue.destination is CustomizeFlavorViewController {
            let vc = segue.destination as? CustomizeFlavorViewController
             
                vc?.type = type
                vc?.shape = shape
                vc?.size = size

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

