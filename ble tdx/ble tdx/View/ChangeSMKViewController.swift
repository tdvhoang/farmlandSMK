//
//  ChangeSMKViewController.swift
//  ble tdx
//
//  Created by iky on 6/8/18.
//  Copyright © 2018 iky. All rights reserved.
//

import UIKit

class ChangeSMKViewController: BaseVC, BLESMKDelegate {
    func update(_ currSMK: String) { 
        ble.user.pinSMK = currSMK
        ble.user.saveValue()
        updateUI()
    }
    
    func error(_ message: String) {
        showAlert(message)
    }
    
    func success(_ message: String) {
        ble.user.pinSMK = message
        ble.user.saveValue()
        updateUI();
        showAlert("Đổi PIN SMK thành công")
    }
    

    @IBOutlet weak var txtCurrPINSMK: UITextField!
    
    @IBOutlet weak var txtNewPINSMK: UITextField!
    
    
    @IBAction func OnclickSave(_ sender: Any) {
        ble.writeSMK(txtNewPINSMK.text!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ble.delegateSMK = self
        
        if(ble.isConnected()){
            ble.readSMK()
            
        }
    }

    
    func updateUI(){
        txtCurrPINSMK.text = "Mã hiện tại: " + ble.user.pinSMK
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
