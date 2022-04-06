import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore
import AuthenticationServices
import Stripe

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        STPPaymentConfiguration.shared.publishableKey = "pk_test_51KjtMtIWELFFeQ7EhQ12RzkvbnjLPOmA0eCkPVPQzYppWMJzbdF2U6GhIymjOxNeo0ERylUiu99dZK3c4gsA2jgH007w3ifWxa"
        
        FirebaseApp.configure( )
        let db =  Firestore.firestore()

        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
       
    }

   
}
