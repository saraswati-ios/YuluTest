//
//  PlaceTableViewCell.swift
//  YuluTest
//
//  Created by Saraswati C on 20/10/19.
//  Copyright © 2019 company. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imgPlace: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
