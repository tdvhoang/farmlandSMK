//
//  ChangeBikeInfViewController.swift
//  iky.smartkey
//
//  Created by iky on 4/20/18.
//  Copyright © 2018 iky. All rights reserved.
//

import UIKit

class ChangeBikeInfViewController: BaseVC {

    @IBOutlet weak var txtInfor: UITextField!
    
    var content : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtInfor.text = content!
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func saveData() -> Void {
        if(title == "Tên người dùng"){
            ble.user.username = txtInfor.text
            
        }else if(title == "Loại xe"){
            ble.user.modelBike = txtInfor.text
            
        }else if(title == "Biển số"){
            ble.user.numberBike = txtInfor.text
        }
        ble.user.saveValue()
    }
}
