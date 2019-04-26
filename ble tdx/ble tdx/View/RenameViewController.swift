

import UIKit

class RenameViewController: BaseVC, BLERenameDelegate {
    @IBOutlet weak var txtNewName: UITextField!
    
    func updateInfor() -> Void {
        //ulNameDevice.text = BLE.shared.user.namedevice
        //rlNameUser.text = BLE.shared.user.username
        //ufModelBike.text = BLE.shared.user.modelBike
        //ulNumberBike.text = BLE.shared.user.numberBike
    }
    
    func rename(_ newname: String) {
        BLE.shared.user.namedevice = newname
        BLE.shared.user.saveValue()
        updateInfor()
        error("Đổi tên thiết bị thành công")
    }
    
    func error(_ message: String) {
        let alert = UIAlertController(title: "Cảnh báo", message: message, preferredStyle: .alert)
        let destroyAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        alert.addAction(destroyAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func saveNewName(_ sender: Any) {
        BLE.shared.rename(txtNewName.text!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BLE.shared.delegateRename = self
        
        self.txtNewName.becomeFirstResponder()
    }
}
