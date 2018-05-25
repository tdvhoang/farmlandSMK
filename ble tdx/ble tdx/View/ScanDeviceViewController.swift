//
//  ScanDeviceViewController.swift
//  iky.smartkey
//
//  Created by iky on 4/19/18.
//  Copyright © 2018 iky. All rights reserved.
//

import UIKit
import CoreBluetooth

class ScanDeviceViewController: BaseVC, UITableViewDelegate, UITableViewDataSource, BLEDiscoverPeripheral {
    
    @IBOutlet weak var tbPeripheral: UITableView!
    
    var peripherals : [ScannedPeripheral]!
    var bluetoothManager : CBCentralManager!
    var timer : Timer!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("peripherals.count = ",peripherals.count)
        return peripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let view = tableView.dequeueReusableCell(withIdentifier: "PeripheralCell") as! ScanTableViewCell
        view.lbName.text = peripherals[indexPath.row].name()
        //view.detailTextLabel?.text = peripherals[indexPath.row].uuid()
        view.imgSignal.image = getRSSIImage(peripherals[indexPath.row].rssi)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let peripheral = peripherals[indexPath.row].peripheral
        ble.scannedPeripheral = peripheral
        ble.user.uuid = peripheral?.identifier.uuidString
        //ble.user.saveValue()
        showAlertInputPin()
        
    }
    
    func discover(_ peripheral: CBPeripheral, rssi: NSNumber) {
        var sensor = ScannedPeripheral(peripheral: peripheral, rssi: rssi.intValue, isConnected: false)
        if(!peripherals.contains(sensor)){
            peripherals.append(sensor)
        }else{
            sensor =  peripherals[ peripherals.index(of: sensor)! ]
            sensor.rssi = rssi.intValue
        }
    }
    
    @objc func timerFireMethod(){
        if(peripherals.count > 0){
            tbPeripheral.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = UIRectEdge()
        ble = BLE.sharedInstance
        ble.delegaatePeripheral = self
        peripherals = [ScannedPeripheral]()
        tbPeripheral.delegate = self
        tbPeripheral.dataSource = self
        
        let uiBusy : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        uiBusy.hidesWhenStopped = true
        uiBusy.startAnimating()
        let uibarbuttonitem = UIBarButtonItem()
        uibarbuttonitem.customView = uiBusy
        self.navigationItem.rightBarButtonItem = uibarbuttonitem
        
        self.ble.user.clearDevice()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ScanDeviceViewController.timerFireMethod), userInfo: nil, repeats: true)
        ble.scanForPeripheral(true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        //UIImage(named: "bg.png")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        ble.scanForPeripheral(false)
        if(timer != nil){
            timer.invalidate()
            timer = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getRSSIImage(_ rssi : Int) -> UIImage {
        
        
        let image: UIImage!
        if (rssi < -90)
        {
            image = UIImage(named:"Signal_0")
        }
        else if (rssi < -70)
        {
            image = UIImage(named:"Signal_1")
        }
        else if (rssi < -50)
        {
            image = UIImage(named:"Signal_2")
        }
        else
        {
            image = UIImage(named:"Signal_3")
        }
        return image
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
            if(tf!.text?.characters.count != 4){
                let alertLengthInput = UIAlertController(title: "Cảnh báo", message: "Mật khẩu gồm 4 chữ", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                    
                }
                alertLengthInput.addAction(cancelAction)
                
                let destroyAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    
                }
                alertLengthInput.addAction(destroyAction)
                self.present(alertLengthInput, animated: true, completion: nil)
                
            }else{
                self.ble.user.pin = tf?.text
                self.ble.bleProtocol.pin = self.ble.user.pin
                self.ble.user.saveValue()
                
                print ("PIN: ",self.ble.user.pin)
                
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) {
            
        }
    }

}
