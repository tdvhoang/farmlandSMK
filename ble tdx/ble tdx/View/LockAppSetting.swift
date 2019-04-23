//
//  LockAppSetting.swift
//  farmland smk
//
//  Created by Hoang Tran on 9/5/18.
//  Copyright © 2018 iky. All rights reserved.
//

import UIKit
import LocalAuthentication

class LockAppSetting: UITableViewController {
    
    @IBOutlet var lblChangePassCode: UILabel!
    @IBOutlet var lblUseTouchID: UILabel!
    @IBOutlet var switchUseTouchID: UISwitch!
    @IBOutlet var switchUsePassCode: UISwitch!
    
    private let laContext = LAContext()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateUI()
    }
    
    private func updateUI() {
        var error: NSError?
        var canUseBiometricAuthentication = self.laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        if #available(iOS 11.0, *) {
            switch self.laContext.biometryType {
            case .faceID:
                self.lblUseTouchID.text = "Dùng Face ID"
            case .touchID:
                self.lblUseTouchID.text = "Dùng vân tay"
            default:
                self.lblUseTouchID.isEnabled = false
                self.switchUseTouchID.isEnabled = false
                self.switchUseTouchID.isOn = false
                self.switchUseTouchID.isUserInteractionEnabled = false
                canUseBiometricAuthentication = false
            }
        }
        self.switchUsePassCode.isOn = BLE.shared.user.usePassCode
        self.switchUseTouchID.isOn = BLE.shared.user.useTouchID
        if BLE.shared.user.usePassCode {
            self.lblChangePassCode.isEnabled = true
            self.switchUseTouchID.isEnabled = canUseBiometricAuthentication
            self.switchUseTouchID.isUserInteractionEnabled = canUseBiometricAuthentication
            self.lblUseTouchID.isEnabled = canUseBiometricAuthentication
        }
        else {
            self.lblChangePassCode.isEnabled = false
            self.switchUseTouchID.isEnabled = false
            self.switchUseTouchID.isUserInteractionEnabled = false
            self.lblUseTouchID.isEnabled = false
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            BLE.shared.user.usePassCode = !BLE.shared.user.usePassCode
            if BLE.shared.user.usePassCode == false {
                BLE.shared.user.passCode = ""
                BLE.shared.user.saveValue()
            }
            else {
                BLE.shared.user.usePassCode = false
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "ChangePassCode", sender: nil)
                }
            }
            self.updateUI()
            
        case 1:
            if BLE.shared.user.usePassCode {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "ChangePassCode", sender: nil)
                }
            }
            
        case 2:
            var error: NSError?
            if self.laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) && BLE.shared.user.usePassCode {
                BLE.shared.user.useTouchID = !BLE.shared.user.useTouchID
                BLE.shared.user.saveValue()
            }
            self.updateUI()
            
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier?.caseInsensitiveCompare("ChangePassCode") == .orderedSame {
            if let vc = segue.destination as? InputPassCodeViewController {
                vc.type = .InputPassCode
            }
        }
    }

}
