//
//  playListTableViewCell.swift
//  videoPlayer
//
//  Created by  wj on 15/11/21.
//  Copyright © 2015年 gzq. All rights reserved.
//

import UIKit

class playListTableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var palyListImage: UIImageView!
    @IBOutlet weak var labelTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
