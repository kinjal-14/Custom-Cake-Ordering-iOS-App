import UIKit

class CustomizeDesignViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var name = ""
    var image = ""
    var customizeCake = [CustomizeCake]()
    var type = ""
    var shape = ""
    var size = ""
    var flavour = ""
    var design = "Doll Cake"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let customizeCake1 = CustomizeCake.init(name: "Doll Cake", image: "cake_barbie")
        let customizeCake2 = CustomizeCake.init(name: "Makeup Cake", image: "cake_makeup")
        let customizeCake3 = CustomizeCake.init(name: "Swan Cake", image: "cake_swan")
        let customizeCake4 = CustomizeCake.init(name: "Teddy Cake", image: "cake_teddy")

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
        
        self.performSegue(withIdentifier: "goToCustomizeInfo", sender: self)
    }
    
    @IBAction func cartButtonClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToCart", sender: self)
    }
    
}

extension CustomizeDesignViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
            design = "Doll Cake"
        }
        if(indexPath.item == 1){
            design = "Makeup Cake"
        }
        if(indexPath.item == 2){
            design = "Swan Cake"
        }
        if(indexPath.item == 3){
            design = "Teddy Cake"
        }
        let msg = UIAlertController(title: "Selected design", message: design, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
//            print("OK BUTTON TAPPED")
        })
        msg.addAction(ok)
        self.present(msg, animated: true, completion: nil)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCustomizeInfo"{
            if segue.destination is CustomizeInfoViewController {
            let vc = segue.destination as? CustomizeInfoViewController
             
                vc?.type = type
                vc?.shape = shape
                vc?.size = size
                vc?.flavour = flavour
                vc?.design = design

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

