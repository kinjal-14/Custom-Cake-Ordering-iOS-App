import UIKit
import FirebaseAuth
import FirebaseFirestore

class PremadeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var cake_id = ""
    var cake_name = ""
    var cake_price = ""
    var cake_size = ""
    var cake_image = ""
    var cake_desc = ""
    var cake_cal = ""
    var count = 1
    var products = [Product]()
    var product = Product(cake_id: "", cake_name: "", cake_price: "", cake_size: "", cake_image: "", cake_desc: "", cake_cal: "")
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchProducts()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Identifiers.ProductCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.ProductCell)
        
    }
  
    @IBAction func backButtonClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToHome", sender: self)
        
    }
    
    @IBAction func cartButtonClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToCart", sender: self)
    }
    
    
    func fetchProducts() {

        let db =  Firestore.firestore()
        db.collection("products").getDocuments() { (querySnapshot, err) in
            if err != nil {
                print("error getting documents")
            }
            else{
                for document in querySnapshot!.documents {
                    let values = document.data() as? NSDictionary
                    let name = values?["name"] as? String ?? ""
                    let id = values?["id"] as? String ?? ""
                    let size = values?["size"] as? String ?? ""
                    let price = values?["price"] as? String ?? ""
                    let image = values?["image"] as? String ?? ""
                    let calories = values?["calories"] as? String ?? ""
                    let desc = values?["desc"] as? String ?? ""
                    let type = values?["type"] as? String ?? ""
                    let newProduct = Product.init(cake_id: id, cake_name: name, cake_price: price, cake_size: size, cake_image: image, cake_desc: desc, cake_cal: calories)
                    self.products.append(newProduct)
                   
                   
                }
                self.collectionView.reloadData()
            }
        }
    }
}

extension PremadeViewController : UICollectionViewDelegate, UICollectionViewDataSource,
                                  UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) ->
        Int {
        
            return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.ProductCell, for: indexPath) as? ProductCell {
            
            cell.configureCell(product: products[indexPath.item])
            (cake_name,cake_desc,cake_cal,cake_price,cake_size,cake_image,cake_id) = cell.getData(product: products[indexPath.item])

            return cell
        }
        return UICollectionViewCell()

    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath){
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.ProductCell, for: indexPath) as! ProductCell
        (cake_name,cake_desc,cake_cal,cake_price,cake_size,cake_image,cake_id) = cell.getData(product: products[indexPath.item])

        self.performSegue(withIdentifier: "goToCakeDetails", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToHome"{
            guard segue.destination is ViewController else { return }
        }
        else if segue.identifier == "goToCakeDetails"{
            if segue.destination is CakeDetailsViewController {
            let vc = segue.destination as? CakeDetailsViewController
                print(cake_name)
                print(cake_image)
                print(cake_desc)
                print(cake_price)
                print(cake_size)
                print(cake_cal)

                vc?.product = product
                vc?.cake_name = cake_name
                vc?.cake_image = cake_image
                vc?.cake_id = cake_id
                vc?.cake_desc = cake_desc
                vc?.cake_price = cake_price
                vc?.cake_size = cake_size
                vc?.cake_cal = cake_cal

            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        let cellWidth = (width - 50) / 2
        let cellHeight = cellWidth * 1.5
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}

