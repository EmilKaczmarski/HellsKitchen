//
//  PostViewCell.swift
//  HellsKitchen
//
//  Created by Aleksandra Brzostek on 6/13/20.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit

class PostViewCell: UITableViewCell {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var middleView: UIView!
    
    @IBOutlet weak var rightView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
