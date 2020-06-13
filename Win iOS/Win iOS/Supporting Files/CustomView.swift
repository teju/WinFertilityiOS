//
//  CustomView.swift
//  Win iOS
//
//  Created by ISE10121 on 10/02/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//
protocol customViewDelegate {
    func cancelBtnAction(sender: AnyObject)
    func okayBtnAction(sender: AnyObject)
}

import UIKit

class CustomView: UIView {

    
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var title_Lbl: UILabel!
    @IBOutlet weak var subTitle_Lbl: UILabel!
    @IBOutlet weak var cancelBtnoutlet: UIButton!
    @IBOutlet weak var okayBtnOutlet: UIButton!
    
    var customViewDelegates: customViewDelegate?
    override init(frame: CGRect) {
           super.init(frame: frame)
       self.frame = UIScreen.main.bounds
       Bundle.main.loadNibNamed("CustomView", owner: self, options: nil)
       self.parentView.frame = UIScreen.main.bounds
       self.addSubview(self.parentView)
       }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    @IBAction func cancelBtnAction(_ sender: Any) {
        customViewDelegates?.cancelBtnAction(sender: cancelBtnoutlet)
    }
    @IBAction func okayBtnAction(_ sender: Any) {
        customViewDelegates?.okayBtnAction(sender: okayBtnOutlet)
    }
    func loadingData(titleLabl: String, subTitleLabel: String, cancelBtnTitle: String, okayBtnTitle:String){
        self.title_Lbl.isHidden = false
        self.subTitle_Lbl.isHidden = false
        self.cancelBtnoutlet.isHidden = false
        self.okayBtnOutlet.isHidden = false
        if(titleLabl != ""){
            self.title_Lbl.text = titleLabl
        }else{
            self.title_Lbl.isHidden = true
        }
        if(subTitleLabel != ""){
            self.subTitle_Lbl.text = subTitleLabel
        }else{
            self.subTitle_Lbl.isHidden = true
        }
        if(cancelBtnTitle != ""){
            self.cancelBtnoutlet.setTitle(cancelBtnTitle, for: .normal)
        }else{
            self.cancelBtnoutlet.isHidden = true
        }
        if(okayBtnTitle != ""){
            self.okayBtnOutlet.setTitle(okayBtnTitle, for: .normal)
        }else{
            self.okayBtnOutlet.isHidden = true
        }
    }

}
