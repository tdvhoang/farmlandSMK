

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
    }

}
