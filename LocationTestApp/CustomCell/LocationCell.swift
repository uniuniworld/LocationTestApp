//
//  LocationCell.swift
//  LocationTestApp
//
//  Created by Takahiro Kirifu on 2020/09/23.
//  Copyright © 2020 Takahiro Kirifu. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {

    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
