

import UIKit

class ScanTableViewCell: UITableViewCell {
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var imgSignal: UIImageView!
    
    var per: ScannedPeripheral?
    
    func show(_ per: ScannedPeripheral) {
        self.per = per
        self.lbName.text = per.name()
        self.imgSignal.image = self.getRSSIImage(per.rssi)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.per = nil
    }
    
    func getRSSIImage(_ rssi : Int) -> UIImage {
        let image: UIImage!
        if (rssi < -90)
        {
            image = UIImage(named:"Signal_0")
        }
        else if (rssi < -70)
        {
            image = UIImage(named:"Signal_1")
        }
        else if (rssi < -50)
        {
            image = UIImage(named:"Signal_2")
        }
        else
        {
            image = UIImage(named:"Signal_3")
        }
        return image
    }
}
