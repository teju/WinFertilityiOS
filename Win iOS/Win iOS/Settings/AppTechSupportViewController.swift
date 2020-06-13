//
//  AppTechSupportViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 30/01/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit

class AppTechSupportViewController: UIViewController, customViewDelegate {
    func cancelBtnAction(sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func okayBtnAction(sender: AnyObject) {
        self.customViews.removeFromSuperview()
    }
    
    
    

    @IBOutlet weak var title_Lbl: UILabel!
    @IBOutlet weak var subTitle_Lbl: UILabel!
    @IBOutlet weak var fromName_Lbl: UILabel!
    @IBOutlet weak var emailID_Lbl: UILabel!
    @IBOutlet weak var notes_TextView: UITextView!
    @IBOutlet weak var tabbar: UITabBar!
    var customViews = CustomView()
    override func viewDidLoad() {
        super.viewDidLoad()
        if(LoadLoginData.contractIdentified == "PWC"){
                self.tabbar.items![1].image = UIImage(named: "icon-toolbar-family-building")
                self.tabbar.items![1].selectedImage = UIImage(named: "icon-toolbar-family-building-active")
                self.tabbar.items![2].image = UIImage(named: "icon-toolbar-parental")
                self.tabbar.items![2].selectedImage = UIImage(named: "icon-toolbar-parental-active")
                self.tabbar.items![3].image = UIImage(named: "icon-toolbar-benefits-childcare")
                self.tabbar.items![3].selectedImage = UIImage(named: "icon-toolbar-benefits-childcare-active")
                self.tabbar.items![4].image = UIImage(named: "icon-connect")
                self.tabbar.items![4].selectedImage = UIImage(named: "icon-connect-active")
        }
        self.customViews.customViewDelegates = self
        self.fromName_Lbl.text = LoadLoginData.profileName
        self.emailID_Lbl.text = LoadLoginData.emailID
        
        notes_TextView.layer.borderColor = UIColor.lightGray.cgColor
        notes_TextView.layer.borderWidth = 1.0
        notes_TextView.layer.cornerRadius = 5.0
        if(isSubmitAquasation){
            self.title_Lbl.text = "Connect With a WIN Nurse"
            self.subTitle_Lbl.text = "SUBMIT A QUESTION"
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        presentIndex = "6"
        self.tabbar.selectedItem = tabbar.items?[5]
    }
    @IBAction func backBtnClick(_ sender: Any) {
        isSubmitAquasation = false
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submitBtnClick(_ sender: Any) {
        self.view.endEditing(true)
        guard notes_TextView.text != "" else {
            //alertView(firstTitle: "", secTitle: "Please Check Notes", cancelBtn: "Okay", okayBtnClick: "")
            self.customViews.loadingData(titleLabl: "", subTitleLabel: "Please Check Notes", cancelBtnTitle: "", okayBtnTitle: "Ok")
            self.view.addSubview(self.customViews)
            return
        }
        submittingTheReview()
    }
    func submittingTheReview(){
        var responseDict = [String: String]()
        responseDict["EmailID"] = LoadLoginData.emailID
        responseDict["TextMessage"] = notes_TextView.text!
        ApiCall(requestDict: responseDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.saveTextMessage.Api, successCallback: {(result) in
            if result!["Result"] as! NSNumber == 1 {
                self.customViews.loadingData(titleLabl: "", subTitleLabel: "\(result!["Message"] as! String)", cancelBtnTitle: "Ok", okayBtnTitle: "")
                self.view.addSubview(self.customViews)
            }
        }, failureCallback: {(error) in
            self.customViews.loadingData(titleLabl: "", subTitleLabel: errorMessages, cancelBtnTitle: "Ok", okayBtnTitle: "")
            self.view.addSubview(self.customViews)
        })
    }
}
