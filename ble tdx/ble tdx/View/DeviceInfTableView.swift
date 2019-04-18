
import UIKit

class DeviceInfTableView: UITableViewController {
    
    func updatePINSK(_ pinSK: String) {
        //ble.user.pinSmartkey = pinSK
        ble.user.saveValue()
        updateInfor()
    }
    
    func error() {
        print("ok")
    }
    

    var ble : BLE!
    
    @IBOutlet weak var lbDeviceName: UILabel!
    
    @IBOutlet weak var lbDriverName: UILabel!
    
    @IBOutlet weak var lbBikeType: UILabel!
    
    @IBOutlet weak var lbPinSmartkey: UILabel!
    
    @IBOutlet weak var lbBikeID: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ble = BLE.shared
        //ble.delegateReadPINSK = self
        
        if(ble.isConnected()){
            //ble.readPINSK()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateInfor()
    }

    
    func updateInfor() -> Void {
        lbDeviceName.text = ble.user.namedevice
        lbDriverName.text = ble.user.username
        lbBikeType.text = ble.user.modelBike
        //lbBikeID.text = ble.user.numberBike
        //lbPinSmartkey.text = ble.user.pinSmartkey
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "segue_changedevice"){
    
            if(ble.isConnected()){
                ble.disconnect()
            }
            
        }
    }
}
