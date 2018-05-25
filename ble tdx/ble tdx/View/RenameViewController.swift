//
//  RenameViewController.swift
//  iky.smartkey
//
//  Created by iky on 4/20/18.
//  Copyright © 2018 iky. All rights reserved.
//

import UIKit

class RenameViewController: BaseVC,BLERenameDelegate {
    
    
    @IBOutlet weak var txtNewName: UITextField!
    
    
    func updateInfor() -> Void {
        //ulNameDevice.text = ble.user.namedevice
        //rlNameUser.text = ble.user.username
        //ufModelBike.text = ble.user.modelBike
        //ulNumberBike.text = ble.user.numberBike
    }
    
    func rename(_ newname: String) {
        ble.user.namedevice = newname
        ble.user.saveValue()
        updateInfor()
        error("Đổi tên thiết bị thành công")
    }
    
    func error(_ message: String) {
        let alert = UIAlertController(title: "Cảnh báo", message: message, preferredStyle: .alert)
        let destroyAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        alert.addAction(destroyAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func saveNewName(_ sender: Any) {
        ble.rename(txtNewName.text!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ble.delegateRename = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
