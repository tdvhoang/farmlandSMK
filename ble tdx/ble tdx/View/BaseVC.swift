

import UIKit

class BaseVC: UIViewController, BLEDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BLE.shared.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BLE.shared.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BLE.shared.delegate = self
    }
    
    //MARK BLE delegate
    func connect() {
        hideLoading()
    }
    
    func disconnect() {
        
    }
    
    func showError(_ message: String) {
        let alertError = UIAlertController(title: "Cảnh báo", message: message, preferredStyle: .alert)
        let destroyAction = UIAlertAction(title: "OK", style: .default) { _ in
            
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
}
