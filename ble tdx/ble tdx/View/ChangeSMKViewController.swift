//
//  ChangeSMKViewController.swift
//  ble tdx
//
//  Created by iky on 6/8/18.
//  Copyright © 2018 iky. All rights reserved.
//

import UIKit

class ChangeSMKViewController: BaseVC, BLESMKDelegate {
    
    func update(_ currSMK: String, time: String) {
        ble.user.time = time
        ble.user.pinSMK = currSMK
        ble.user.saveValue()
        updateUI()
    }
    
    func success(_ message: String, time: String) {
        ble.user.time = time
        ble.user.pinSMK = message
        ble.user.saveValue()
        updateUI();
        showAlert("Đổi PIN SMK thành công")
    }
    
    func error(_ message: String) {
        showAlert(message)
    }
    
    @IBOutlet weak var txtTime: UITextField!
    
    @IBOutlet weak var txtCurrPINSMK: UITextField!
    
    @IBOutlet weak var txtNewPINSMK: UITextField!
    
    
    @IBAction func OnclickSave(_ sender: Any) {
        
        let itime:Int? = Int(txtTime.text!)
        let ipin:Int? = Int(txtNewPINSMK.text!)
        var bOK: Bool = true;
        
        if(itime != nil)
        {
            if(itime! < 10 || itime! > 99)
            {
                showAlert("Thời gian phải có giá trị 10 đến 99")
                bOK = false
            }
        }
        else
        {
            showAlert("Thời gian không hợp lệ")
            bOK = false
        }
        
        if(ipin == nil)
        {
            showAlert("Mã PIN không hợp lệ")
            bOK = false
        }
        if( bOK == true)
        {
            ble.writeSMK(txtNewPINSMK.text!,time: txtTime.text!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ble.delegateSMK = self
        
        if(ble.isConnected()){
            ble.readSMK()
        }
    }

    
    func updateUI(){
        txtCurrPINSMK.text = "Mã hiện tại: " + ble.user.pinSMK + "     Thời gian: " + ble.user.time
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUI()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Cảnh báo", message: message, preferredStyle: .alert)
        let destroyAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        alert.addAction(destroyAction)
        self.present(alert, animated: true, completion: nil)
        
    }

}
