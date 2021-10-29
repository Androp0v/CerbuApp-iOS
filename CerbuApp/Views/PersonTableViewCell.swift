//
//  PersonTableViewCell.swift
//  CerbuApp
//
//  Created by Raúl Montón Pinillos on 17/07/2019.
//  Copyright © 2019 Raúl Montón Pinillos. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet var orlaImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var careerLabel: UILabel!
    @IBOutlet var statusImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Make icon image round
        orlaImageView.layer.cornerRadius = orlaImageView.frame.size.height/2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
