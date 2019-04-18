

import UIKit

class RenameViewController: BaseVC,BLERenameDelegate {
    
    
    @IBOutlet weak var txtNewName: UITextField!
    
    
    func updateInfor() -> Void {
        //ulNameDevice.text = ble.user.namedevice
        //rlNameUser.text = ble.user.username
        //ufModelBike.text = ble.user.modelBike
        //ulNumberBike.text = ble.user.numberBike
    }
    
    func rename(_ newname: String) {
        ble.user.namedevice = newname
        ble.user.saveValue()
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
        ble.rename(txtNewName.text!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ble.delegateRename = self
        
        self.txtNewName.becomeFirstResponder()
    }
}
