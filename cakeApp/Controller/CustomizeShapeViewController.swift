import UIKit

class CustomizeShapeViewController: UIViewController {
   
    @IBOutlet weak var collectionView: UICollectionView!
    
    var name = ""
    var image = ""
    var shape = "Hexagon"
    var type = ""
   
    var customizeCake = [CustomizeCake]()
   
    override func viewDidLoad() {
        super.viewDidLoad()

        let customizeCake1 = CustomizeCake.init(name: "Hexagon", image: "cake_five")
        let customizeCake2 = CustomizeCake.init(name: "Heart", image: "cake_six")
        let customizeCake3 = CustomizeCake.init(name: "Round", image: "cake_one")
        let customizeCake4 = CustomizeCake.init(name: "Square", image: "cake_square")

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
        
        self.performSegue(withIdentifier: "goToCustomizeSize", sender: self)
    }
    
    @IBAction func cartButtonClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToCart", sender: self)
    }
}

extension CustomizeShapeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
            shape = "Hexagon"
        }
        if(indexPath.item == 1){
            shape = "Heart"
        }
        if(indexPath.item == 2){
            shape = "Round"
        }
        if(indexPath.item == 3){
            shape = "Square"
        }
        let msg = UIAlertController(title: "Selected shape", message: shape, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
//            print("OK BUTTON TAPPED")
        })
        msg.addAction(ok)
        self.present(msg, animated: true, completion: nil)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCustomizeSize"{
            if segue.destination is CustomizeSizeViewController {
            let vc = segue.destination as? CustomizeSizeViewController
             
                vc?.type = type
                vc?.shape = shape

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
