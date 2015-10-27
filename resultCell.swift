//
//  resultCell.swift
//  ChatApp
//
//  Created by TangWeichang on 10/4/15.
//  Copyright © 2015 TangWeichang. All rights reserved.
//

import UIKit

class resultCell: UITableViewCell {

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var profilenameLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        let theWidth = UIScreen.mainScreen().bounds.width
        contentView.frame = CGRectMake(0, 0, theWidth, 120)
        profileImage.center = CGPointMake(60, 60)
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        profilenameLable.center = CGPointMake(230, 55)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
