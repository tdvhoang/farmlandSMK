

import UIKit

class ControlViewController: BaseVC, BLEStatusDelegate, BLELogonDelegate {
    
    func success() {
        
        hideLoading()
        imgConnect.image = UIImage(named:"ic_connect")
        
        ble.readStatus()
    }
    
    
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
    
    
    @IBAction func onClickCMD1(_ sender: Any) {
        if(cmd1_status)
        {
            ble.sendCMD1(false)
        }
        else
        {
            ble.sendCMD1(true)
        }
    }
    
    
    @IBAction func onClickCMD2(_ sender: Any) {
        if(cmd2_status)
        {
            ble.sendCMD2(false)
        }
        else
        {
            ble.sendCMD2(true)
        }
    }
    

    @IBAction func onClickCMD3(_ sender: Any) {
        if(cmd3_status)
        {
            ble.sendCMD3(false)
        }
        else
        {
            ble.sendCMD3(true)
        }
    }
    
    
    @IBAction func onClickCMD4(_ sender: Any) {
        if(cmd4_status)
        {
            ble.sendCMD4(false)
        }
        else
        {
            ble.sendCMD4(true)
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
            self.ble.disconnect()
            self.scanDevice()
            
        }
        alert.addAction(destroyAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidload")
        ble.delegateStatus = self;
        ble.delegateLogon = self;
        
        if(ble.isConnected()){
            ble.readStatus()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotification(_:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Status viewDidAppear")
        //updateInfor()
        imgConnect.image = UIImage(named:"ic_disconnect")
        
        if !ble.hasValue() {
            
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
            if(!ble.isConnected()){
                print("Disconnected")
                ble.connectToPeripheral(ble.scannedPeripheral!)
            }else{
                print("Connected---->>>>>>>>>>>>")
                ble.readStatus()
            }
        }
    }
    
    func scanDevice() {
        print("scandevice")
        self.navigationController?.popToRootViewController(animated: false)
        self.performSegue(withIdentifier: "scandevice", sender: self)
    }
    
    @objc func handleNotification(_ noti: NSNotification) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if Date().timeIntervalSince(appDelegate.lastActiveDate) > 5 {
                if let passCode = User.shared.passCode {
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
