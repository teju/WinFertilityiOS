//
//  NotesView.swift
//  Win iOS
//
//  Created by ISE10121 on 17/04/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit

class NotesView: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var plusBtnOutlet: UIButton!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }

    @objc dynamic var forceBackgroundColor: UIColor? {
        get { return self.contentView.backgroundColor }
        set(color) {
            self.contentView.backgroundColor = color
            // if your color is not opaque, adjust backgroundView as well
            self.backgroundView?.backgroundColor = .clear
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
