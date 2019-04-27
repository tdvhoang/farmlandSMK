

import UIKit

class RenameViewController: BaseVC, BLERenameDelegate {
    @IBOutlet weak var txtNewName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BLE.shared.delegateRename = self
        
        self.txtNewName.becomeFirstResponder()
    }
    
    @IBAction func saveNewName(_ sender: Any) {
        BLE.shared.rename(txtNewName.text!)
    }
    
    func rename(_ newname: String) {
        BLE.shared.user.namedevice = newname
        BLE.shared.user.saveValue()
        error("Đổi tên thiết bị thành công")
    }
    
    func error(_ message: String) {
        let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
        let destroyAction = UIAlertAction(title: "OK", style: .default) { _ in
            
        }
        alert.addAction(destroyAction)
        self.present(alert, animated: true, completion: nil)
    }
}
