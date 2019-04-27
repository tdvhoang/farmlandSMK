

import UIKit
import CoreBluetooth

class ScanDeviceViewController: BaseVC, UITableViewDelegate, UITableViewDataSource, BLEDiscoverPeripheral {
    
    @IBOutlet weak var tbPeripheral: UITableView!
    
    var peripherals : [ScannedPeripheral]!
    var bluetoothManager : CBCentralManager!
    var timer : Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = UIRectEdge()
        BLE.shared.delegaatePeripheral = self
        peripherals = [ScannedPeripheral]()
        tbPeripheral.delegate = self
        tbPeripheral.dataSource = self
        
        let uiBusy : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        uiBusy.hidesWhenStopped = true
        uiBusy.startAnimating()
        let uibarbuttonitem = UIBarButtonItem()
        uibarbuttonitem.customView = uiBusy
        self.navigationItem.rightBarButtonItem = uibarbuttonitem
        
        BLE.shared.user.clearDevice()
        BLE.shared.disconnect()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ScanDeviceViewController.timerFireMethod), userInfo: nil, repeats: true)
        BLE.shared.scanForPeripheral(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        BLE.shared.scanForPeripheral(false)
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func discover(_ peripheral: CBPeripheral, rssi: NSNumber) {
        if let sensor = self.getExistedPeripheral(peripheral) {
            if sensor.rssi != rssi.intValue {
                DispatchQueue.main.async {
                    for aCell in self.tbPeripheral.visibleCells {
                        if let aCell = aCell as? ScanTableViewCell, let per = aCell.per {
                            if per == sensor {
                                if let indexPath = self.tbPeripheral.indexPath(for: aCell) {
                                    self.tbPeripheral.reloadRows(at:  [indexPath], with: .none)
                                }
                            }
                        }
                    }
                }
            }
            sensor.rssi = rssi.intValue
        }
        else {
            let sensor = ScannedPeripheral(peripheral: peripheral, rssi: rssi.intValue, isConnected: false)
            peripherals.append(sensor)
        }
    }
    
    @objc func timerFireMethod() {
        if self.peripherals.count > 0 {
            self.tbPeripheral.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.peripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeripheralCell") as! ScanTableViewCell
        cell.show(peripherals[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let peripheral = peripherals[indexPath.row].peripheral
        BLE.shared.scannedPeripheral = peripheral
        BLE.shared.user.uuid = peripheral?.identifier.uuidString
        //ble.user.saveValue()
        showAlertInputPin()
    }
    
    func showAlertInputPin(){
        let alertController = UIAlertController(title: "Nhập mật khẩu", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Mật khẩu"
            textField.keyboardType = .numberPad
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let tf = alertController.textFields?.first
            if tf!.text?.count != 4 {
                let alertLengthInput = UIAlertController(title: "Cảnh báo", message: "Mật khẩu gồm 4 ký tự", preferredStyle: .alert)
                let destroyAction = UIAlertAction(title: "OK", style: .default) { _ in
                    
                }
                alertLengthInput.addAction(destroyAction)
                self.present(alertLengthInput, animated: true, completion: nil)
            }
            else {
                BLE.shared.user.pin = tf?.text
                BLE.shared.bleProtocol.pin = BLE.shared.user.pin
                BLE.shared.user.saveValue()
                
                print ("PIN: ",BLE.shared.user.pin)
                
                self.navigationController?.popViewController(animated: true)
            }
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func getExistedPeripheral(_ per: CBPeripheral) -> ScannedPeripheral? {
        for aPre in self.peripherals {
            if aPre.uuid() == per.identifier.uuidString {
                return aPre
            }
        }
        return nil
    }
}
