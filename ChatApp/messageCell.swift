//
//  messageCell.swift
//  ChatApp
//
//  Created by TangWeichang on 10/25/15.
//  Copyright © 2015 TangWeichang. All rights reserved.
//

import UIKit

class messageCell: UITableViewCell {
    @IBOutlet var usernameLbl: UILabel!

    @IBOutlet var messageLbl: UILabel!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
