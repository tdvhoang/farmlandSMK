

import UIKit

class BaseVC: UIViewController, BLEDelegate {

    var ble : BLE!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ble = BLE.shared
        ble.delegate = self

        // Do any additional setup after loading the view.

    }
    
    //MARK BLE delegate
    func connect() {
        hideLoading()
        
    }
    func disconnect() {
        
    }
    
    func showError(_ message: String) {

        let alertError = UIAlertController(title: "Cảnh báo", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        alertError.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        alertError.addAction(destroyAction)
        self.present(alertError, animated: true, completion: nil)
        
    }
    func showLoading(_ message : String) {
        MBProgressHUD.hide(for: self.view, animated: true)
        let hud = MBProgressHUD.showAdded(to: self.view, animated:true)
        hud.label.text = message
        
    }
    func hideLoading() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
