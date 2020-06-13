//
//  TextfieldEffects.swift
//  Win iOS
//
//  Created by BALARAM SOMINENI on 07/01/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit

private var maxLengthDictionary = [UITextField : Int]()
class ZWTextField : UITextField {

    var topBorder: UIView?
    var bottomBorder: UIView?
    var leftBorder: UIView?
    var rightBorder: UIView?
    var leftimageview : UIImageView?
    var rightimageview : UIImageView?
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var ULText: Bool = false {
        didSet {
            let textRange = NSMakeRange(0, (self.text?.count)!)
            let attributedText = NSMutableAttributedString(string: (self.text)!)
            attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value:NSUnderlineStyle.single.rawValue, range: textRange)
            self.attributedText = attributedText
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var fitToWidth: Bool = false {
        didSet {
            adjustsFontSizeToFitWidth = fitToWidth
        }
    }
    @IBInspectable var cursorColor : UIColor = UIColor.blue {
        didSet {
            tintColor = cursorColor
        }
    }

    @IBInspectable var placeHolderColor : UIColor = UIColor.lightGray{
        didSet {
            setValue(placeHolderColor, forKeyPath: "_placeholderLabel.textColor")
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    @IBInspectable var rightImage : UIImage? {
        didSet {
            if rightImage != nil {
                let width = rightviewWidth > rightImage!.size.width ? rightviewWidth :  rightImage!.size.width
                rightViewMode = UITextField.ViewMode.always
                rightimageview = UIImageView()
                rightimageview!.frame = CGRect(x: self.frame.size.width - width, y: self.frame.origin.y+2, width: width,height: self.frame.size.height-4)
                rightimageview!.image = rightImage
                rightView = rightimageview
                self.rightViewMode = .always
                rightimageview!.contentMode = .center
            }
            else {
                if rightimageview != nil {
                    rightimageview?.removeFromSuperview()
                    rightimageview = nil
                }
            }
        }
    }
    @IBInspectable var rightviewWidth : CGFloat = 0 {
        didSet{
            if rightimageview != nil{
                let width = rightviewWidth > rightImage!.size.width + 10 ? rightviewWidth :  rightImage!.size.width + 10
                rightimageview!.frame = CGRect(x: self.frame.origin.x+5, y: self.frame.origin.y+2, width: width,height: self.frame.size.height-4)
            }
        }
    }
    @IBInspectable var leftImage : UIImage? {
        didSet {
            if leftImage != nil {
                let width = leftviewWidth > leftImage!.size.width + 10 ? leftviewWidth :  leftImage!.size.width + 10
                leftViewMode = UITextField.ViewMode.always
                leftimageview = UIImageView();
                leftimageview!.frame = CGRect(x: self.frame.origin.x+50, y: self.frame.origin.y+5, width: width,height: self.frame.size.height-5)
                //leftimageview!.frame = CGRectMake(10, 5, 40, 40)
                leftimageview!.image = leftImage;
                leftView = leftimageview;
                self.leftViewMode = .always
                leftimageview!.contentMode = .center
            }
        }
    }
    @IBInspectable var leftviewWidth : CGFloat = 0 {
        didSet{
            if leftimageview != nil{
                let width = leftviewWidth > leftImage!.size.width + 10 ? leftviewWidth :  leftImage!.size.width + 10
                leftimageview!.frame = CGRect(x: self.frame.origin.x+5, y: self.frame.origin.y+2, width: width,height: self.frame.size.height-4)
            }
        }
    }
    @IBInspectable var bottomLineWidth : CGFloat = 1 {
        didSet{
            let border: CALayer = CALayer()
            border.borderColor = UIColor.darkGray.cgColor
            self.frame = CGRect(x: 0, y: self.frame.size.height - bottomLineWidth, width: self.frame.size.width, height: self.frame.size.height)
            border.borderWidth = borderWidth
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
        }
    }

    @IBInspectable var bottomLineColor : UIColor = UIColor.lightGray{
        didSet {
            let border: CALayer = CALayer()
            border.borderColor = bottomLineColor.cgColor
        }
    }
    @IBInspectable var paddingLeft: CGFloat = 0
    @IBInspectable var paddingRight: CGFloat = 0

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + paddingLeft, y: bounds.origin.y,
                      width: bounds.size.width - paddingLeft - paddingRight, height: bounds.size.height);
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    @IBInspectable var topBorderColor : UIColor = UIColor.clear
    @IBInspectable var topBorderHeight : CGFloat = 0 {
        didSet{
            if topBorder == nil{
                topBorder = UIView()
                topBorder?.backgroundColor=topBorderColor;
                topBorder?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: topBorderHeight)
                addSubview(topBorder!)
            }
        }
    }
    @IBInspectable var bottomBorderColor : UIColor = UIColor.clear
    @IBInspectable var bottomBorderHeight : CGFloat = 0 {
        didSet{
            if bottomBorder == nil{
                bottomBorder = UIView()
                bottomBorder?.backgroundColor=bottomBorderColor;
                bottomBorder?.frame = CGRect(x: 0, y: self.frame.size.height - bottomBorderHeight, width: self.frame.size.width, height: bottomBorderHeight)
                addSubview(bottomBorder!)
            }
        }
    }
    @IBInspectable var leftBorderColor : UIColor = UIColor.clear
    @IBInspectable var leftBorderHeight : CGFloat = 0 {
        didSet{
            if leftBorder == nil{
                leftBorder = UIView()
                leftBorder?.backgroundColor=leftBorderColor;
                leftBorder?.frame = CGRect(x: 0, y: 0, width: leftBorderHeight, height: self.frame.size.height)
                addSubview(leftBorder!)
            }
        }
    }
    @IBInspectable var rightBorderColor : UIColor = UIColor.clear
    @IBInspectable var rightBorderHeight : CGFloat = 0 {
        didSet{
            if rightBorder == nil{
                rightBorder = UIView()
                rightBorder?.backgroundColor=topBorderColor;
                rightBorder?.frame = CGRect(x: self.frame.size.width - rightBorderHeight, y: 0, width: rightBorderHeight, height: self.frame.size.height)
                addSubview(rightBorder!)
            }
        }
    }
    @IBInspectable var maxLength: Int {
        get {
            if let length = maxLengthDictionary[self] {
                return length
            } else {
                return Int.max
            }
        }
        set {
            maxLengthDictionary[self] = newValue
            addTarget(self, action: #selector(checkMaxLength), for: UIControl.Event.editingChanged)
        }
    }

  @objc  func checkMaxLength(sender: UITextField) {
        let newText = sender.text
        if (newText?.count)! > maxLength {
            let cursorPosition = selectedTextRange
            text = (newText! as NSString).substring(with: NSRange(location: 0, length: maxLength))
            selectedTextRange = cursorPosition
        }
    }
}
import UIKit
var presentIndex = ""

extension UIViewController: UITabBarDelegate {
    public func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if (item.tag == 1){
            if(presentIndex != "1"){
                if(LoadLoginData.contractIdentified == "PWC"){
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PwcViewController") as? PwcViewController
             self.navigationController?.pushViewController(vc!, animated: true)
                }else{
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
            }
        }else if (item.tag == 2){
            if(presentIndex != "2"){
                
                if (UserDefaults.standard.bool(forKey: UserDefaultsStored.UserLogedInOrNot)){
                    if(LoadLoginData.contractIdentified == "PWC"){
                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FamilyBuildingViewController") as? FamilyBuildingViewController
                        self.navigationController?.pushViewController(vc!, animated: true)
                    }else{
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NurseConnectViewController") as? NurseConnectViewController
            self.navigationController?.pushViewController(vc!, animated: true)
                    }
                }else{
                   let vc = HomeViewController()
                   vc.showPopUp()
                }
            }
        }else if (item.tag == 3){
            if(presentIndex != "3"){
                if(LoadLoginData.contractIdentified == "PWC"){
                    pwcvalidator = "parantalsupport"
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChildCareSupportViewController") as? ChildCareSupportViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                }else{
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "INformationCenterViewController") as? INformationCenterViewController
            self.navigationController?.pushViewController(vc!, animated: true)
                }
            }
        }else if (item.tag == 4){
            if(presentIndex != "4"){
                if (UserDefaults.standard.bool(forKey: UserDefaultsStored.UserLogedInOrNot)){
                    if(LoadLoginData.contractIdentified == "PWC"){
                        pwcvalidator = "childcaresupport"
                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChildCareSupportViewController") as? ChildCareSupportViewController
                        self.navigationController?.pushViewController(vc!, animated: true)
                    }else{
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UnderStandBenefitsViewController") as? UnderStandBenefitsViewController
            self.navigationController?.pushViewController(vc!, animated: true)
                    }
                }else{
                    let vc = HomeViewController()
                    vc.showPopUp()
                }
            }
        }else if (item.tag == 5){
            if(presentIndex != "5"){
                if (UserDefaults.standard.bool(forKey: UserDefaultsStored.UserLogedInOrNot)){
                    if(LoadLoginData.contractIdentified == "PWC"){
                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NurseConnectViewController") as? NurseConnectViewController
                        self.navigationController?.pushViewController(vc!, animated: true)
                    }else{
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FertilityTrackerViewController") as? FertilityTrackerViewController
            self.navigationController?.pushViewController(vc!, animated: true)
                    }
                }else{
                    let vc = HomeViewController()
                    vc.showPopUp()
                }
            }
        }else if (item.tag == 6){
            if(presentIndex != "6"){
                if (UserDefaults.standard.bool(forKey: UserDefaultsStored.UserLogedInOrNot)){
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController
            self.navigationController?.pushViewController(vc!, animated: true)
                }else{
                    let vc = HomeViewController()
                    vc.showPopUp()
                }
            }
        }
    }
}

