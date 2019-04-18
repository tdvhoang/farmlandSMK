

import UIKit

class VersionViewController: BaseVC,BLEVersionDelegate {
    
    @IBOutlet weak var lbVersion: UILabel!
    @IBOutlet weak var imgvContent: UIImageView!
    
    func updateVersion(version: String) {
        lbVersion.text = "Phiên bản " + version
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        ble.delegateVersion = self
        
        if ble.isConnected() {
            ble.version()
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.imgvContent.image = UIImage(named: "intro_content_ipad_portrail")
        }
        else {
            self.imgvContent.image = UIImage(named: "intro_content_iphone_portrail")
        }
    }
}
