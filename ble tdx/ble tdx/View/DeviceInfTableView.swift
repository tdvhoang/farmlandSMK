
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
        
        ble = BLE.sharedInstance
        //ble.delegateReadPINSK = self
        
        if(ble.isConnected()){
            //ble.readPINSK()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        updateInfor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func updateInfor() -> Void {
        lbDeviceName.text = ble.user.namedevice
        lbDriverName.text = ble.user.username
        lbBikeType.text = ble.user.modelBike
        lbBikeID.text = ble.user.numberBike
        //lbPinSmartkey.text = ble.user.pinSmartkey
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "segue_drivername"){
            let vc = segue.destination as! ChangeBikeInfViewController
            vc.title = "Tên người dùng"
            vc.content = ble.user.username
        }else if(segue.identifier == "segue_biketype"){
            let vc = segue.destination as! ChangeBikeInfViewController
            vc.title = "Loại xe"
            vc.content = ble.user.modelBike
        }else if(segue.identifier == "segue_bikeid"){
            let vc = segue.destination as! ChangeBikeInfViewController
            vc.title = "Biển số"
            vc.content = ble.user.numberBike
        }else if(segue.identifier == "segue_changedevice"){
    
            if(ble.isConnected()){
                ble.disconnect()
            }
            
        }
    }
}
