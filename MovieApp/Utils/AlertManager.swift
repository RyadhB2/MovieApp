
import UIKit

class AlertManager {
    private static func showBasicAlert(on vc : UIViewController,title: String, message: String?){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"Dismiss",style:.default,handler: nil))
            vc.present(alert,animated: true)
        }
                        
    }
}


//  Fetch Data errors
extension AlertManager {

    public static func showLoadingDataErrorAlert(on vc : UIViewController){
        self.showBasicAlert(on: vc, title: "Error while loading data", message: "Please try again ..." )
    }
}

