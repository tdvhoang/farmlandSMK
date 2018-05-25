//
//  VersionViewController.swift
//  iky.smartkey
//
//  Created by iky on 4/20/18.
//  Copyright © 2018 iky. All rights reserved.
//

import UIKit

class VersionViewController: BaseVC,BLEVersionDelegate {
    
    @IBOutlet weak var lbVersion: UILabel!
    
    func updateVersion(version: String) {
        lbVersion.text = "Phiên bản " + version
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        ble.delegateVersion = self
        
        if(ble.isConnected()){
            ble.version()
        }
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
