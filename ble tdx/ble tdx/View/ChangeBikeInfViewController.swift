

import UIKit

class ChangeBikeInfViewController: BaseVC {

    @IBOutlet weak var txtInfor: UITextField!
    
    var content : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtInfor.text = content!
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func saveData() -> Void {
        if(title == "Tên người dùng"){
            ble.user.username = txtInfor.text
            
        }else if(title == "Loại xe"){
            ble.user.modelBike = txtInfor.text
            
        }else if(title == "Biển số"){
            ble.user.numberBike = txtInfor.text
        }
        ble.user.saveValue()
    }
}
