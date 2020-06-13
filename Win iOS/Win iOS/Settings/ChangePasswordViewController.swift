//
//  ChangePasswordViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 10/02/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController, customViewDelegate {
    
    

    @IBOutlet weak var currentPassword_Txt: UITextField!
    @IBOutlet weak var newPassword_Txt: UITextField!
    @IBOutlet weak var confirmPassword_Txt: UITextField!
    
    @IBOutlet weak var tabbar: UITabBar!
    var customView =  CustomView()
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
        self.customView.customViewDelegates = self
        presentIndex = "6"
        self.tabbar.selectedItem = tabbar.items?[5]
        
    }
    func cancelBtnAction(sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func okayBtnAction(sender: AnyObject) {
        self.customView.removeFromSuperview()
    }
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submitBtnClick(_ sender: Any) {
        self.view.endEditing(true)
        let validate = self.validateFields()
        
        if validate.isValidated {
            self.changePassword()
        }
        else {
         
        }
    }
    func changePassword() {
        var requestDict = [String: String]()
        requestDict["EmailID"]     = LoadLoginData.emailID
        requestDict["OldPassword"] = currentPassword_Txt.text!
        requestDict["NewPassword"] = newPassword_Txt.text!
        ApiCall(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.changePassword.Api, successCallback: {(result) in
            if (result!["Message"] as! String == "Your password has been chnaged successfully."){
                UserDefaults.standard.set(self.newPassword_Txt.text!, forKey: UserDefaultsStored.password)
            self.customView.loadingData(titleLabl: "", subTitleLabel: "Your password successfully changed.", cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(self.customView)
            }else{
                self.customView.loadingData(titleLabl: "", subTitleLabel: "\(result!["Message"] as! String)", cancelBtnTitle: "", okayBtnTitle: "Okay")
                self.view.addSubview(self.customView)
            }
        }, failureCallback: {(error) in
            self.customView.loadingData(titleLabl: "", subTitleLabel: errorMessages, cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(self.customView)
        })
    }
    
    func validateFields() -> (isValidated:Bool, validationMessage:String) {
        
        var isValidated = true
        var validationMssg = ""
        if currentPassword_Txt.text == "" {
            isValidated    = false
            validationMssg = ""
        }
        else if newPassword_Txt.text == "" {
            isValidated = false
            validationMssg = ""
        } else if !isPasswordValid(newPassword_Txt.text!) {
            isValidated = false
            validationMssg = ""
        }
        else if confirmPassword_Txt.text == "" {
            isValidated = false
            validationMssg = ""
        }
        else if (newPassword_Txt.text != confirmPassword_Txt.text) {
            isValidated = false
            validationMssg = ""
        }
        return (isValidated, validationMssg)
    }

}
