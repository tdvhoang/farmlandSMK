
import UIKit

class DeviceInfTableView: UITableViewController {
    
    @IBOutlet weak var lbDeviceName: UILabel!
    @IBOutlet weak var lbDriverName: UILabel!
    @IBOutlet weak var lbBikeType: UILabel!
    @IBOutlet weak var lbPinSmartkey: UILabel!
    @IBOutlet weak var lbBikeID: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if BLE.shared.isConnected() {
            //BLE.shared.readPINSK()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateInfor()
    }
    
    func updatePINSK(_ pinSK: String) {
        BLE.shared.user.saveValue()
        updateInfor()
    }
    
    func error() {
        print("ok")
    }
    
    func updateInfor() -> Void {
        lbDeviceName.text = BLE.shared.user.namedevice
        lbDriverName.text = BLE.shared.user.username
        lbBikeType.text = BLE.shared.user.modelBike
        //lbBikeID.text = BLE.shared.user.numberBike
        //lbPinSmartkey.text = BLE.shared.user.pinSmartkey
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_changedevice" {
            if BLE.shared.isConnected() {
                BLE.shared.disconnect()
            }
        }
    }
}
