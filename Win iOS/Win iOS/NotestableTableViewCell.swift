//
//  NotestableTableViewCell.swift
//  Win iOS
//
//  Created by ISE10121 on 17/04/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit

class NotestableTableViewCell: UITableViewCell {

    @IBOutlet weak var title_Lbl: UILabel!
    @IBOutlet weak var subtitle_Lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
