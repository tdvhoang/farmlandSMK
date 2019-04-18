
import UIKit

class ChangePassWordViewController: BaseVC, BLEChangePassDelegate {
    
    
    func success() {
        ble.user.pin = txtNewPassword.text!
        ble.user.saveValue()
        ble.bleProtocol.pin = txtNewPassword.text!
        let alertMessage = UIAlertController(title: "Cảnh báo", message: "Đổi mật khẩu thành công", preferredStyle: .alert)
        
        let destroyAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alertMessage.addAction(destroyAction)
        self.present(alertMessage, animated: true, completion: nil)
    }
    
    func error(_ message: String) {
        showAlert(message)
    }
    

    
    @IBOutlet weak var txtOldPassword: UITextField!
    
    @IBOutlet weak var txtNewPassword: UITextField!
    
    @IBOutlet weak var txtNewPasswordConfirm: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ble.delegateChangePass = self
        
        self.txtOldPassword.becomeFirstResponder()
    }
    

    @IBAction func OnClickedSave(_ sender: Any) {
        
        if(!txtOldPassword.text!.isEqual(ble.user.pin)){
            showAlert("Mật khẩu cũ không đúng")
            return
        }
        
        if(txtNewPassword.text!.count != 4){
            showAlert("Mật khẩu gồm 4 chữ số!")
            return
        }
        
        if(!txtNewPassword.text!.isEqual(txtNewPasswordConfirm.text!)){
            showAlert("Mật khẩu không trùng!")
            return
        }
        ble.changePass(txtNewPassword.text!)
        
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
