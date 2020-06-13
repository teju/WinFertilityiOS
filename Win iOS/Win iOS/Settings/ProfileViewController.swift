//
//  ProfileViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 30/01/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

var goalTexts = ""
var goalValidator = Bool()

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate, customViewDelegate, ToolbarPickerViewDelegate {
    func didTapDone() {
        self.view.endEditing(true)
    }
    
    func didTapCancel() {
        self.view.endEditing(true)
    }
    
    
    @IBOutlet weak var firstName_Txt: ZWTextField!
    @IBOutlet weak var lastName_Txt: ZWTextField!
    @IBOutlet weak var dateOfBirth_Txt: ZWTextField!
    @IBOutlet weak var gender_Txt: ZWTextField!
    @IBOutlet weak var phoneNumber_Txt: ZWTextField!
    @IBOutlet weak var emailAddress_Txt: ZWTextField!
    @IBOutlet weak var goal_Txt: CustomTextView!
    @IBOutlet weak var employer_Txt: ZWTextField!
    @IBOutlet weak var employerCode: ZWTextField!
    @IBOutlet weak var secureCode_Txt: ZWTextField!
    
    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var goals_Txt_Height: NSLayoutConstraint!
    
    
    let genderCollection = ["Select","Female","Male","Not Specified","Prefer not to say"]
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
        goalTexts = ""
        goalValidator = false
        customViews.customViewDelegates = self
        dateOfBirth_Txt.addInputViewDatePicker(target: self, selector: #selector(endTimedoneButtonPressed), maxDate: Date(), minDate: Calendar.current.date(byAdding: .year, value: -40, to: Date()), datePickerMode: .date)
        firstName_Txt.text = LoadLoginData.firstName
        lastName_Txt.text = LoadLoginData.lastName
        dateOfBirth_Txt.text = Utils.getStringFromDate(date: Utils.getDateFromString(dateStr: LoadLoginData.dOB, format: "MM/dd/yyyy"), format: "MMM dd yyyy")
        gender_Txt.text = LoadLoginData.gender
        phoneNumber_Txt.text = LoadLoginData.mobileNumber
        emailAddress_Txt.text = LoadLoginData.emailID
        goalTexts = LoadLoginData.goal
        goal_Txt.text = LoadLoginData.goal
        employer_Txt.text = LoadLoginData.employer
        employerCode.text = LoadLoginData.employerCode
        secureCode_Txt.text = LoadLoginData.secureCode
        gender_Txt.delegate = self
        callingApi(str: "View Profile")
        if(LoadLoginData.secureCode != ""){
            secureCode_Txt.isUserInteractionEnabled = false
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        goals_Txt_Height.constant = self.goal_Txt.contentSize.height
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == gender_Txt){
            gender_Txt.loadDropdownData(data: genderCollection)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        presentIndex = "6"
        self.tabbar.selectedItem = tabbar.items?[5]
        goal_Txt.text = goalTexts.replacingOccurrences(of: ",", with: ".\n")
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
        goal_Txt.addGestureRecognizer(tap)
        goal_Txt.isEditable = false
    }
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        goalTexts = LoadLoginData.goal
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GoalsViewController") as? GoalsViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @objc func endTimedoneButtonPressed(){
        if let  datePicker = self.dateOfBirth_Txt.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd yyyy"
            self.dateOfBirth_Txt.text = "\(dateFormatter.string(from: datePicker.date))"
        }
        self.dateOfBirth_Txt.resignFirstResponder()
    }
    @IBAction func changePasswordBtnClick(_ sender: Any) {
        
    }
    func cancelBtnAction(sender: AnyObject) {
        customViews.removeFromSuperview()
    }
    
    func okayBtnAction(sender: AnyObject) {
        customViews.removeFromSuperview()
    }
    @IBAction func saveBtnClick(_ sender: Any) {
        guard firstName_Txt.text != "" else {
            customViews.loadingData(titleLabl: "", subTitleLabel: "Please Check First Name", cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(customViews)
            return
        }
        guard lastName_Txt.text != "" else {
            customViews.loadingData(titleLabl: "", subTitleLabel: "Please Check Last Name", cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(customViews)
            return
        }
        guard dateOfBirth_Txt.text != "" else {
            customViews.loadingData(titleLabl: "", subTitleLabel: "Please Check Date of Birth", cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(customViews)
            return
        }
        guard gender_Txt.text != "Select" else {
            customViews.loadingData(titleLabl: "", subTitleLabel: "Please Check Gender", cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(customViews)
            return
        }
        guard phoneNumber_Txt.text != "" else {
            customViews.loadingData(titleLabl: "", subTitleLabel: "Please Check Phone Number", cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(customViews)
            return
        }
        guard emailAddress_Txt.text != "" else {
            customViews.loadingData(titleLabl: "", subTitleLabel: "Please Check Email Id", cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(customViews)
            return
        }
        guard !(!validateEmail(email: emailAddress_Txt.text!)) else {
            customViews.loadingData(titleLabl: "", subTitleLabel: "Please Check Email Id", cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(customViews)
            return
        }
        guard goal_Txt.text != "" else {
            customViews.loadingData(titleLabl: "", subTitleLabel: "Please Check Goal", cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(customViews)
            return
        }
        updateAccount()
    }
    func updateAccount(){
        var requestDict             = [String: String]()
        requestDict["FirstName"]    = firstName_Txt.text
        requestDict["LastName"]     = lastName_Txt.text
        requestDict["EmailID"]      = emailAddress_Txt.text
        requestDict["PhoneNo"]      = phoneNumber_Txt.text
        requestDict["DOB"]          = dateOfBirth_Txt.text
        requestDict["Company"]      = employer_Txt.text
        requestDict["Gender"]       = gender_Txt.text
        requestDict["Promocode"]    = employerCode.text
        requestDict["SecureCode"]   = secureCode_Txt.text
        requestDict["WINBenefits"]  = ""
        requestDict["Goal"]         = goalTexts
        requestDict["DeviceType"] = "iOS"
        requestDict["UpdateFlag"] = "Y"
        requestDict["PWD"]      = ""
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        requestDict["Version"] = appVersion
        ApiCall(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.createAccount.Api, successCallback: {(result) in
            let loginData = logindata(json: result!)
            if(LoadLoginData.secureCode != ""){
                self.secureCode_Txt.isUserInteractionEnabled = false
            }else{
                self.secureCode_Txt.isUserInteractionEnabled = true
            }
            self.customViews.loadingData(titleLabl: "", subTitleLabel: "Your profile has been updated successfully", cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(self.customViews)
            if (loginData.message == "") {
                
            }
        }, failureCallback: {(error) in
            self.customViews.loadingData(titleLabl: "", subTitleLabel: errorMessages, cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(self.customViews)
        })
    }
}
