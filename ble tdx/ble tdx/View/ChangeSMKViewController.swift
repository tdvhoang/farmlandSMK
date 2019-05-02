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
    @IBOutlet weak var btnShowSMK: UIButton!
    
    private var fullSMK = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BLE.shared.delegateSMK = self
        
        if BLE.shared.isConnected() {
            BLE.shared.readSMK()
        }
        
        self.btnShowSMK.clipsToBounds = true
        self.btnShowSMK.layer.cornerRadius = 5
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
            BLE.shared.writeSMK(self.txtNewPINSMK.text!,time: txtTime.text!)
        }
    }
    
    @IBAction func showFullSMK() {
        if self.fullSMK == false {
            let alertController = UIAlertController(title: "Thông báo", message: "Nhập mật khẩu thiết bị", preferredStyle: .alert)
            
            alertController.addTextField { (textField) in
                textField.placeholder = "Mật khẩu"
                textField.keyboardType = .numberPad
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { _ in
                if let tf = alertController.textFields?.first {
                    if tf.text?.count != 4 {
                        let alertLengthInput = UIAlertController(title: "Cảnh báo", message: "Mật khẩu gồm 4 ký tự", preferredStyle: .alert)
                        let destroyAction = UIAlertAction(title: "OK", style: .default) { _ in
                            
                        }
                        alertLengthInput.addAction(destroyAction)
                        self.present(alertLengthInput, animated: true, completion: nil)
                    }
                    else if BLE.shared.user.pin != tf.text {
                        let alertLengthInput = UIAlertController(title: "Cảnh báo", message: "Sai mật khẩu", preferredStyle: .alert)
                        let destroyAction = UIAlertAction(title: "OK", style: .default) { _ in
                            self.showFullSMK()
                        }
                        alertLengthInput.addAction(destroyAction)
                        self.present(alertLengthInput, animated: true, completion: nil)
                    }
                    else {
                        self.fullSMK = true
                        self.updateUI()
                    }
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            self.fullSMK = false
            self.updateUI()
        }
    }
    
    func updateUI() {
        var pinSMK = ""
        if let smk = BLE.shared.user.pinSMK {
            pinSMK = smk
            if self.fullSMK == false {
                if pinSMK.count > 6 {
                    pinSMK = pinSMK.prefix(2) + "..." + pinSMK.suffix(2)
                }
            }
        }
        self.txtCurrPINSMK.text = "Mã hiện tại: " + pinSMK + "     Thời gian: " + BLE.shared.user.time
        self.btnShowSMK.setTitle(self.fullSMK ? "Ẩn": "Xem", for: .normal)
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
