//
//  WinForHimViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 17/02/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit

class WinForHimViewController: UIViewController, customViewDelegate {
    func cancelBtnAction(sender: AnyObject) {
        self.customViews.removeFromSuperview()
    }
    
    func okayBtnAction(sender: AnyObject) {
        self.customViews.removeFromSuperview()
    }
    

    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var textLabel: UILabel!
    var customViews = CustomView()
    override func viewDidLoad() {
        super.viewDidLoad()
        if(LoadLoginData.contractIdentified == "PWC"){
            presentIndex = "2"
                self.tabbar.selectedItem = tabbar.items?[1]
                self.tabbar.items![1].image = UIImage(named: "icon-toolbar-family-building")
                self.tabbar.items![1].selectedImage = UIImage(named: "icon-toolbar-family-building-active")
                self.tabbar.items![2].image = UIImage(named: "icon-toolbar-parental")
                self.tabbar.items![2].selectedImage = UIImage(named: "icon-toolbar-parental-active")
                self.tabbar.items![3].image = UIImage(named: "icon-toolbar-benefits-childcare")
                self.tabbar.items![3].selectedImage = UIImage(named: "icon-toolbar-benefits-childcare-active")
                self.tabbar.items![4].image = UIImage(named: "icon-connect")
                self.tabbar.items![4].selectedImage = UIImage(named: "icon-connect-active")
        }else{
            self.tabbar.selectedItem = tabbar.items?[0]
        }
       // textLabel.text = "\u{2022}  Discretely test and store your sperm sample. \n\n\u{2022}   Discuss results with dedicated WINFertility Nurse Care Manager. \n\n\u{2022}  Access to reproductive behavioral health counseling. \n\n\u{2022}  Access WIN's highly credentialed fertility specialists for treatment."
        let bullet1 = "Discreetly delivered to you, deposit your sperm from the comfort of your own home."
        let bullet2 = "Free overnight shipping of kit back to the lab."
        let bullet3 = "Once received by the lab, test results available within 24 hrs."
        let bullet4 = "Access to WIN’s Nurse Care Managers to explain semen analysis results, discuss potential medical procedures and answer questions."
        let bullet5 = "Sperm deposits are securely cryogenically stored until you’re ready to use it."
        let strings = [bullet1, bullet2, bullet3, bullet4, bullet5]
        let attributesDictionary = [NSAttributedString.Key.font : textLabel.font]
        let fullAttributedString = NSMutableAttributedString(string: "", attributes: attributesDictionary as [NSAttributedString.Key : Any])
                 
              for string: String in strings
               {
                   let bulletPoint: String = "\u{2022}"
                   let formattedString: String = "\(bulletPoint) \(string)\n\n"
                   let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: formattedString)
                   let paragraphStyle = createParagraphAttribute()
                attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attributedString.length))
                    
                fullAttributedString.append(attributedString)
               }
               textLabel.attributedText = fullAttributedString
        customViews.customViewDelegates = self
        callingApi(str: "WIN for Him")
    }
    func createParagraphAttribute() ->NSParagraphStyle
       {
           var paragraphStyle: NSMutableParagraphStyle
        paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
           paragraphStyle.defaultTabInterval = 15
           paragraphStyle.firstLineHeadIndent = 0
           paragraphStyle.headIndent = 15
           return paragraphStyle
       }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func orderYourKIt(_ sender: Any) {
        callingApi(str: "Order Your Kit")
        if(LoadLoginData.dadiProgram == "Yes"){
            guard let url = URL(string: LoadLoginData.dadiLink) else { return }
        UIApplication.shared.open(url)
        }else{
            self.customViews.loadingData(titleLabl: "", subTitleLabel: "This service is currently not included in your program.", cancelBtnTitle: "Ok", okayBtnTitle: "")
            self.view.addSubview(customViews)
        }
    }
}
func callingApi(str: String){
    var requestDict = [String: String]()
    requestDict["EmailID"]    = LoadLoginData.emailID
    requestDict["Activity"]    = str
    ApiCallss(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.saveCallRecorderLog.Api, successCallback: {(result) in
        
    }, failureCallback: {(error) in
        
    })
}
