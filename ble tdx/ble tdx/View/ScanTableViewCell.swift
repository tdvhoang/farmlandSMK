//
//  ScanTableViewCell.swift
//  iky.smartkey
//
//  Created by iky on 4/19/18.
//  Copyright © 2018 iky. All rights reserved.
//

import UIKit

class ScanTableViewCell: UITableViewCell {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var imgSignal: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
