

import UIKit

class ChangeBikeInfViewController: BaseVC {

    @IBOutlet weak var txtInfor: UITextField!
    
    var content : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtInfor.text = content!
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveData()
    }

    func saveData() -> Void {
        if(title == "Tên người dùng"){
            BLE.shared.user.username = txtInfor.text
            
        }else if(title == "Loại xe"){
            BLE.shared.user.modelBike = txtInfor.text
            
        }
        BLE.shared.user.saveValue()
    }
}
