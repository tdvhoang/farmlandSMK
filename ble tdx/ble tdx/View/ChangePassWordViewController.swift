
import UIKit

class ChangePassWordViewController: BaseVC, BLEChangePassDelegate {
    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtNewPasswordConfirm: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BLE.shared.delegateChangePass = self
        self.txtOldPassword.becomeFirstResponder()
    }
    
    @IBAction func OnClickedSave(_ sender: Any) {
        if !txtOldPassword.text!.isEqual(BLE.shared.user.pin) {
            showAlert("Mật khẩu cũ không đúng")
            return
        }
        
        if self.txtNewPassword.text!.count != 4 {
            showAlert("Mật khẩu gồm 4 ký tự!")
            return
        }
        
        if !self.txtNewPassword.text!.isEqual(txtNewPasswordConfirm.text!) {
            showAlert("Mật khẩu không trùng!")
            return
        }
        BLE.shared.changePass(txtNewPassword.text!)
    }
    
    func success() {
        BLE.shared.user.pin = self.txtNewPassword.text!
        BLE.shared.user.saveValue()
        BLE.shared.bleProtocol.pin = txtNewPassword.text!
        let alertMessage = UIAlertController(title: "Thông báo", message: "Đổi mật khẩu thành công", preferredStyle: .alert)
        
        let destroyAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alertMessage.addAction(destroyAction)
        self.present(alertMessage, animated: true, completion: nil)
    }
    
    func error(_ message: String) {
        showAlert(message)
    }
    
    func showAlert(_ message : String) -> Void {
        let alertMessage = UIAlertController(title: "Cảnh báo", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alertMessage.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        alertMessage.addAction(destroyAction)
        self.present(alertMessage, animated: true, completion: nil)
    }
}
