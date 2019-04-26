//
//  ViewController.swift
//  iky.smartkey
//
//  Created by iky on 4/16/18.
//  Copyright © 2018 iky. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate,CBPeripheralDelegate {
    
    var cbCentralManager : CBCentralManager?
    var ble : BLE!
    var discoveredPeripheral : CBPeripheral?
    var ikyBikeCharacteristic : CBCharacteristic?
    var uuidService : CBUUID?
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if(central.state == CBManagerState.poweredOff){
            
            print("didUpdateState powser off" )
        }else if(central.state == CBManagerState.poweredOn){
            print("didUpdateState powwer on and ready" )
            //            cbCentralManager?.scanForPeripheralsWithServices([uuidService!], options: nil)
            cbCentralManager?.scanForPeripherals(withServices: nil, options: nil)
            showLoadding()
        }else if(central.state == CBManagerState.unauthorized){
            print("didUpdateState unauthorize on" )
        }else if(central.state == CBManagerState.unknown){
            print("didUpdateState unknow on" )
        }else if(central.state == CBManagerState.unsupported){
            print("didUpdateState unsupport on" )
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Do any additional setup after loading the view, typically from a nib" )
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func showLoadding(){
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading"
        
    }
    
    @IBAction func onClickStart(_ sender: AnyObject) {
        showLoadding()
        cbCentralManager?.scanForPeripherals(withServices: nil, options: nil)
    }
    @IBAction func onClickWrite(_ sender: AnyObject) {
        if( self.discoveredPeripheral != nil){
            //let value = tfWriteValue.text?.data(using: String.Encoding.utf8)
            //self.discoveredPeripheral?.writeValue(value!, for: ikyBikeCharacteristic!, type: CBCharacteristicWriteType.withResponse)
            
        }else{
            print("peripheral is nil")
        }
    }
    @IBAction func onClickRead(_ sender: AnyObject) {
        if( self.discoveredPeripheral != nil){
            self.discoveredPeripheral?.readValue(for: ikyBikeCharacteristic!)
        }else{
            print("peripheral is nil")
        }
        
        
    }


}

