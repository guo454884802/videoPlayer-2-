//
//  onlineTableViewCell.swift
//  videoPlayer
//
//  Created by  wj on 15/12/1.
//  Copyright © 2015年 gzq. All rights reserved.
//

import UIKit

class onlineTableViewCell: UITableViewCell {

    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
