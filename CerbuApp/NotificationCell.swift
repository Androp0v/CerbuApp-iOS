//
//  NotificationCell.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 14/10/2019.
//  Copyright © 2019 Raúl Montón Pinillos. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var message: UITextView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
