//
//  InputPassCodeViewController.swift
//  farmland smk
//
//  Created by Hoang Tran on 9/6/18.
//  Copyright © 2018 iky. All rights reserved.
//

import UIKit
import LocalAuthentication

enum InputPassCodeType {
    case InputPassCode
    case VerifyPassCode
    case CreatePassCode
}

class InputPassCodeViewController: UIViewController {
    
    @IBOutlet var lblInputPassCode: UILabel!
    @IBOutlet var lblMesage: UILabel!
    @IBOutlet var vNumber1: UIView!
    @IBOutlet var vNumber2: UIView!
    @IBOutlet var vNumber3: UIView!
    @IBOutlet var vNumber4: UIView!
    @IBOutlet var btn1: UIButton!
    @IBOutlet var btn2: UIButton!
    @IBOutlet var btn3: UIButton!
    @IBOutlet var btn4: UIButton!
    @IBOutlet var btn5: UIButton!
    @IBOutlet var btn6: UIButton!
    @IBOutlet var btn7: UIButton!
    @IBOutlet var btn8: UIButton!
    @IBOutlet var btn9: UIButton!
    @IBOutlet var btn0: UIButton!
    @IBOutlet var btnBackSpace: UIButton!
    @IBOutlet var btnCancel: UIBarButtonItem!
    
    var type: InputPassCodeType = InputPassCodeType.CreatePassCode
    var passCodeToVerify: String!
    private var inputNumberAsString = ""
    private lazy var numberButtons: [UIButton] = [self.btn0, self.btn1, self.btn2, self.btn3, self.btn4, self.btn5, self.btn6, self.btn7, self.btn8, self.btn9]
    private lazy var vNumbers: [UIView] = [self.vNumber1, self.vNumber2, self.vNumber3, self.vNumber4]
    
    private lazy var laContext: LAContext = LAContext()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch self.type {
        case .CreatePassCode:
            self.lblInputPassCode.text = "Nhập mã khoá"
            self.btnCancel.isEnabled = true
            break
        case .VerifyPassCode:
            self.lblInputPassCode.text = "Xác nhận lại mã khoá"
            self.btnCancel.isEnabled = true
            break
        case .InputPassCode:
            self.lblInputPassCode.text = "Nhập mã khoá"
            self.btnCancel.isEnabled = false
            if User.shared.useTouchID {
                self.prepareForTouchID()
            }
            break
        }
        self.navigationItem.hidesBackButton = true
        
        for (index, button) in self.numberButtons.enumerated() {
            button.addTarget(self, action: #selector(self.handleNumberButton(_:)), for: .touchUpInside)
            button.setTitleColor(UIColor.blue, for: .highlighted)
            button.tag = index
        }
        
        for aView in self.vNumbers {
            aView.clipsToBounds = true
            aView.layer.cornerRadius = aView.frame.size.width / 2
            aView.layer.borderWidth = 1
            aView.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
            aView.backgroundColor = UIColor.white
        }
        
        self.btnCancel.target = self
        self.btnCancel.action = #selector(self.handleCancelButton(_:))
        self.btnBackSpace.addTarget(self, action: #selector(self.handleBackSpaceButton(_:)), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotification(_:)), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleNotification(_ noti: NSNotification) {
        if self.type != .InputPassCode {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func handleNumberButton(_ btn: UIButton) {
        if self.inputNumberAsString.count < 4 {
            self.inputNumberAsString += String(format: "%ld", btn.tag)
        }
        
        if self.inputNumberAsString.count == 4 {
            switch self.type {
            case .CreatePassCode:
                if let verifyPassCodeVC = self.storyboard?.instantiateViewController(withIdentifier: "InputPassCodeViewController") as? InputPassCodeViewController {
                    verifyPassCodeVC.type = .VerifyPassCode
                    verifyPassCodeVC.passCodeToVerify = self.inputNumberAsString
                    self.inputNumberAsString = ""
                    self.navigationController?.pushViewController(verifyPassCodeVC, animated: true)
                }
            case .VerifyPassCode:
                if let passCodeToVerify = self.passCodeToVerify, self.inputNumberAsString.caseInsensitiveCompare(passCodeToVerify) == .orderedSame {
                    var error: NSError?
                    User.shared.usePassCode = true
                    User.shared.useTouchID = self.laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
                    User.shared.passCode = self.inputNumberAsString
                    User.shared.saveValue()
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }
                else {
                    let alertVC = UIAlertController(title: nil, message: "Mã khoá không trùng.\nVui lòng nhập lại", preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                            self.navigationController?.popToRootViewController(animated: true)
                        })
                    }))
                    self.present(alertVC, animated: true, completion: nil)
                }
                break
            case .InputPassCode:
                if self.inputNumberAsString.compare(User.shared.passCode) == .orderedSame {
                    if let rootVC = UIApplication.shared.delegate?.window??.rootViewController {
                        if self.navigationController == rootVC {
                            UIApplication.shared.delegate?.window??.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                        }
                        else {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
                else {
                    self.lblMesage.isHidden = false
                    self.inputNumberAsString = ""
                    self.lblMesage.text = "Mã khoá không đúng"
                }
                break
            }
        }
        else {
            self.lblMesage.isHidden = true
        }
        self.updateUI()
    }
    
    @objc private func handleCancelButton(_ btn: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleBackSpaceButton(_ btn: UIButton) {
        if self.inputNumberAsString.count > 0 {
            self.inputNumberAsString = self.inputNumberAsString.dropLast().lowercased()
            self.lblMesage.isHidden = true
            self.updateUI()
        }
    }
    
    private func updateUI() {
        for (index, aView) in self.vNumbers.enumerated() {
            if index < self.inputNumberAsString.count {
                aView.backgroundColor = UIColor.blue
                aView.layer.borderColor = UIColor.blue.cgColor
            }
            else {
                aView.backgroundColor = UIColor.white
                aView.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
            }
        }
    }
    
    //MARK: - Touch ID
    private func prepareForTouchID() {
        var error: NSError?
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if self.laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                self.laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Mở khoá ứng dụng") { (success, error) in
                    appDelegate.lastActiveDate = Date()
                    if success {
                        DispatchQueue.main.async {
                            if (appDelegate.window?.rootViewController as? UINavigationController)?.topViewController is InputPassCodeViewController {
                                appDelegate.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                            }
                            else {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }

}
