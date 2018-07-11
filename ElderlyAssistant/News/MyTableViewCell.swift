//
//  MyTableViewCell.swift
//  OlderApp
//
//  Created by 刘帅 on 2018/2/9.
//  Copyright © 2018年 段佳伟. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    var showImage: UIImageView?
    var content: UILabel?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        showImage = UIImageView()
        content = UILabel()
        self.contentView.addSubview(self.content!)
        self.contentView.addSubview(self.showImage!)
        self.setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupViews(){
        self.showImage?.frame = CGRect(x: 20, y: 15, width: UIScreen.main.bounds.width/5, height: 50)
    
        self.content?.frame = CGRect(x: UIScreen.main.bounds.width/3.6, y: 5, width: UIScreen.main.bounds.width/1.6, height: 75)
        self.content?.font = UIFont(name: "", size: 15)
        self.content?.textAlignment = NSTextAlignment.left
        self.content?.numberOfLines = 0
        self.content?.adjustsFontSizeToFitWidth = true
        
    }

}
