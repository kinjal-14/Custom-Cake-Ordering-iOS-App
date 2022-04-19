import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import AuthenticationServices

class CustomizeCakeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var name = ""
    var image = ""
    var type = "Regular"
    var customizeCake = [CustomizeCake]()
   
    override func viewDidLoad() {
        super.viewDidLoad()

        let db =  Firestore.firestore()
        let userID = Auth.auth().currentUser?.uid ?? ""

        if Auth.auth().currentUser != nil {
    
            db.collection("users").document(userID).getDocument() { [self] (querySnapshot, err) in
                if err != nil {
                    print("error getting documents")
                }
                else{
                    print(querySnapshot?.data())
                    let fullnameField = querySnapshot?["fullname"] as? String ?? ""
//                    self.fullnameField.text = fullnameField
            
                }
            }
        }
        
        let customizeCake1 = CustomizeCake.init(name: "Regular", image: "cake_two")
        let customizeCake2 = CustomizeCake.init(name: "Vegan", image: "cake_three")
        let customizeCake3 = CustomizeCake.init(name: "Gluten Free", image: "cake_four")
        let customizeCake4 = CustomizeCake.init(name: "Sugar Free", image: "cake_seven")

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
        
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "goToCustomizeShape", sender: self)
        }
        else{
            let msg = UIAlertController(title: "Alert", message: "Login Required..!!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        self.performSegue(withIdentifier: "goToLogin", sender: self)
            })
            msg.addAction(ok)
            self.present(msg, animated: true, completion: nil)
            
        }
        self.performSegue(withIdentifier: "goToCustomizeShape", sender: self)

    }
  
    @IBAction func cartButtonClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToCart", sender: self)
    }
    
}

extension CustomizeCakeViewController : UICollectionViewDelegate, UICollectionViewDataSource,
                                  UICollectionViewDelegateFlowLayout {
    
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
            type = "Regular"
        }
        if(indexPath.item == 1){
            type = "Vegan"
        }
        if(indexPath.item == 2){
            type = "Gluten Free"
        }
        if(indexPath.item == 3){
            type = "Sugar Free"
        }
        let msg = UIAlertController(title: "Selected type", message: type, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
//            print("OK BUTTON TAPPED")
        })
        msg.addAction(ok)
        self.present(msg, animated: true, completion: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCustomizeShape"{
            if segue.destination is CustomizeShapeViewController {
            let vc = segue.destination as? CustomizeShapeViewController
             
                vc?.type = type

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
