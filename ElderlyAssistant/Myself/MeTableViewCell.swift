//
//  MeTableViewCell.swift
//  ElderlyAssistant
//
//  Created by 段佳伟 on 2018/1/26.
//  Copyright © 2018年 2015110410. All rights reserved.
//

import UIKit

class MeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var Mimage: UIImageView!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
