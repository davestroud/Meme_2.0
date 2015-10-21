//
//  MemeTableViewCell.swift
//  meme_v2
//
//  Created by John David Stroud on 10/19/15.
//  Copyright © 2015 greymatter-home. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var title: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
