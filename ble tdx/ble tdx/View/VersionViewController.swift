

import UIKit

class VersionViewController: BaseVC,BLEVersionDelegate {
    
    @IBOutlet weak var lbVersion: UILabel!
    @IBOutlet weak var imgvContent: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        BLE.shared.delegateVersion = self
        
        if BLE.shared.isConnected() {
            BLE.shared.version()
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.imgvContent.image = UIImage(named: "intro_content_ipad_portrail")
        }
        else {
            self.imgvContent.image = UIImage(named: "intro_content_iphone_portrail")
        }
    }
    
    func updateVersion(version: String) {
        lbVersion.text = "Phiên bản " + version
    }
}
