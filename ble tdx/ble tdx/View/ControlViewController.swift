

import UIKit

class ControlViewController: BaseVC, BLEStatusDelegate, BLELogonDelegate {
    @IBOutlet weak var imgConnect: UIImageView!
    @IBOutlet weak var btnCMD1: UIButton!
    @IBOutlet weak var btnCMD2: UIButton!
    @IBOutlet weak var btnCMD3: UIButton!
    @IBOutlet weak var btnCMD4: UIButton!
    
    var protect_status = true
    var cmd1_status = true
    var cmd2_status = true
    var cmd3_status = true
    var cmd4_status = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BLE.shared.delegateStatus = self
        BLE.shared.delegateLogon = self
        
        if BLE.shared.isConnected() {
            BLE.shared.readStatus()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotification(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Status viewDidAppear")
        //updateInfor()
        imgConnect.image = UIImage(named:"ic_disconnect")
        
        if !BLE.shared.hasValue() {
            let alertScanDevice = UIAlertController(title: "Cảnh báo", message: "Vui lòng tìm thiết bị", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Bỏ qua", style: .cancel) { (action) in
                
            }
            
            alertScanDevice.addAction(cancelAction)
            
            let destroyAction = UIAlertAction(title: "Đồng ý", style: .default) { (action) in
                self.scanDevice()
            }
            
            alertScanDevice.addAction(destroyAction)
            self.present(alertScanDevice, animated: true, completion: nil)
        }else{
            if(!BLE.shared.isConnected()){
                print("Disconnected")
                BLE.shared.connectToPeripheral(BLE.shared.scannedPeripheral!)
            }else{
                print("Connected---->>>>>>>>>>>>")
                BLE.shared.readStatus()
            }
        }
    }
    
    func success() {
        hideLoading()
        imgConnect.image = UIImage(named:"ic_connect")
        
        BLE.shared.readStatus()
    }
    
    @IBAction func onClickCMD1(_ sender: Any) {
        if cmd1_status {
            BLE.shared.sendCMD1(false)
        }
        else {
            BLE.shared.sendCMD1(true)
        }
    }
    
    @IBAction func onClickCMD2(_ sender: Any) {
        if cmd2_status {
            BLE.shared.sendCMD2(false)
        }
        else {
            BLE.shared.sendCMD2(true)
        }
    }
    

    @IBAction func onClickCMD3(_ sender: Any) {
        if cmd3_status {
            BLE.shared.sendCMD3(false)
        }
        else {
            BLE.shared.sendCMD3(true)
        }
    }
    
    
    @IBAction func onClickCMD4(_ sender: Any) {
        if cmd4_status {
            BLE.shared.sendCMD4(false)
        }
        else {
            BLE.shared.sendCMD4(true)
        }
    }
    
    func updateStatus(_ cmd1: UInt8, cmd2: UInt8, cmd3: UInt8, cmd4: UInt8) {
        hideLoading()
        
        imgConnect.image = UIImage(named:"ic_connect")
        
        
        if(cmd1 == 1){
            cmd1_status = true
            btnCMD1.setImage(UIImage(named:"ic_cmd1_on"), for: .normal)
        }else{
            cmd1_status = false
            btnCMD1.setImage(UIImage(named:"ic_cmd1_off"), for: .normal)
        }
        
        if(cmd2 == 1){
            cmd2_status = true
            btnCMD2.setImage(UIImage(named:"ic_cmd2_on"), for: .normal)
        }else{
            cmd2_status = false
            btnCMD2.setImage(UIImage(named:"ic_cmd2_off"), for: .normal)
        }
        
        if(cmd3 == 1){
            cmd3_status = true
            btnCMD3.setImage(UIImage(named:"ic_cmd3_on"), for: .normal)
        }else{
            cmd3_status = false
            btnCMD3.setImage(UIImage(named:"ic_cmd3_off"), for: .normal)
        }
        
        if(cmd4 == 1){
            cmd4_status = true
            btnCMD4.setImage(UIImage(named:"ic_cmd4_on"), for: .normal)
        }else{
            cmd4_status = false
            btnCMD4.setImage(UIImage(named:"ic_cmd4_off"), for: .normal)
        }
        
        
    }
    
    func logonerror() {
        let alert = UIAlertController(title: "Cảnh báo", message: "Sai mã pin!", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "OK", style: .default) { (action) in
            BLE.shared.disconnect()
            self.scanDevice()
        }
        alert.addAction(destroyAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func scanDevice() {
        print("scandevice")
        self.navigationController?.popToRootViewController(animated: false)
        self.performSegue(withIdentifier: "scandevice", sender: self)
    }
    
    @objc func handleNotification(_ noti: NSNotification) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if Date().timeIntervalSince(appDelegate.lastActiveDate) > 5 {
                if let passCode = BLE.shared.user.passCode {
                    if passCode.count == 4 {
                        if let topVC = self.view.topMostController() {
                            if (topVC is InputPassCodeViewController) == false {
                                if let inputPassCodeNav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InputPassCodeNavigationController") as? UINavigationController, let inputPassCodeVC = inputPassCodeNav.topViewController as? InputPassCodeViewController {
                                    inputPassCodeVC.type = .InputPassCode
                                    topVC.present(inputPassCodeNav, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
