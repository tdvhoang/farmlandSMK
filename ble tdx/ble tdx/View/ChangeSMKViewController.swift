//
//  ChangeSMKViewController.swift
//  ble tdx
//
//  Created by iky on 6/8/18.
//  Copyright © 2018 iky. All rights reserved.
//

import UIKit

class ChangeSMKViewController: BaseVC, BLESMKDelegate {
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var txtCurrPINSMK: UITextField!
    @IBOutlet weak var txtNewPINSMK: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BLE.shared.delegateSMK = self
        
        if BLE.shared.isConnected() {
            BLE.shared.readSMK()
        }
        
        self.txtNewPINSMK.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
    }
    
    @IBAction func OnclickSave(_ sender: Any) {
        
        let itime:Int? = Int(txtTime.text!)
        let ipin:Int? = Int(txtNewPINSMK.text!)
        var bOK: Bool = true
        
        if let itime = itime {
            if(itime < 10 || itime > 99) {
                showAlert("Thời gian phải có giá trị 10 đến 99")
                bOK = false
            }
        }
        else {
            showAlert("Thời gian không hợp lệ")
            bOK = false
        }
        
        if ipin == nil {
            showAlert("Mã PIN không hợp lệ")
            bOK = false
        }
        if bOK {
            BLE.shared.writeSMK(txtNewPINSMK.text!,time: txtTime.text!)
        }
    }
    
    func updateUI() {
        txtCurrPINSMK.text = "Mã hiện tại: " + BLE.shared.user.pinSMK + "     Thời gian: " + BLE.shared.user.time
    }
    
    func update(_ currSMK: String, time: String) {
        BLE.shared.user.time = time
        BLE.shared.user.pinSMK = currSMK
        BLE.shared.user.saveValue()
        updateUI()
    }
    
    func success(_ message: String, time: String) {
        BLE.shared.user.time = time
        BLE.shared.user.pinSMK = message
        BLE.shared.user.saveValue()
        updateUI()
        showAlert("Đổi PIN SMK thành công")
    }
    
    func error(_ message: String) {
        showAlert(message)
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Cảnh báo", message: message, preferredStyle: .alert)
        let destroyAction = UIAlertAction(title: "OK", style: .default) { _ in
            
        }
        alert.addAction(destroyAction)
        self.present(alert, animated: true, completion: nil)
    }
}
