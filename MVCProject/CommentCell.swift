//
//  CommentCell.swift
//  MVCProject
//
//  Created by Leonard on 2017. 1. 21..
//  Copyright © 2017년 Leonard. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
