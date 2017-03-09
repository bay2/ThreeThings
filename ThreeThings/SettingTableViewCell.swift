//
//  SettingTableViewCell.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/3/7.
//  Copyright © 2017年 xuemincai. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet weak var titleLab: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
