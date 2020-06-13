//
//  CreateAccountViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 10/02/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController, customViewDelegate  {
    
    @IBOutlet weak var firstName_Txt: UITextField!
    @IBOutlet weak var lastName_Txt: UITextField!
    @IBOutlet weak var email_Txt: UITextField!
    @IBOutlet weak var createPassword_Txt: UITextField!
    @IBOutlet weak var confirmPassword_Txt: UITextField!
    @IBOutlet weak var firstSwitch: UISwitch!
    @IBOutlet weak var secondSwitch: UISwitch!
    @IBOutlet weak var thirdSwitch: UISwitch!
    @IBOutlet weak var fourthswitch: UISwitch!
    @IBOutlet weak var fivthSwitch: UISwitch!
    @IBOutlet weak var sixthSwitch: UISwitch!
    @IBOutlet weak var dateOfBirth_Txt: UITextField!
    @IBOutlet weak var gender_Txt: UITextField!
    @IBOutlet weak var phoneNumber_Txt: UITextField!
    
    @IBOutlet weak var employerSwitch: UISwitch!
    @IBOutlet weak var companyName_Txt: UITextField!
    @IBOutlet weak var employerCode_Txt: UITextField!
    @IBOutlet weak var secureCode_Txt: UITextField!
    
    @IBOutlet weak var stackView1: UIStackView!
    @IBOutlet weak var stackView2: UIStackView!
    @IBOutlet weak var stackView3: UIStackView!
    @IBOutlet weak var stackView4: UIStackView!
    @IBOutlet weak var stackView5: UIStackView!
    
    var customViews = CustomView()
    var goalsData = ["","","","","",""]
    var validationStr = ""
    var alertViewValidation = ""
    let genderCollection = ["Female","Male","Not Specified","Prefer not to say"]
    var isBtnSelected = "N"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customViews.customViewDelegates = self
        validationStr = "1st"
        self.stackView5.isHidden = true
        gender_Txt.loadDropdownData(data: genderCollection)
        dateOfBirth_Txt.addInputViewDatePicker(target: self, selector: #selector(endTimedoneButtonPressed), maxDate: Date(), minDate: Calendar.current.date(byAdding: .year, value: -40, to: Date()), datePickerMode: .date)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.stackView2.isHidden = true
        self.stackView3.isHidden = true
    }
    @objc func endTimedoneButtonPressed(){
        if let  datePicker = self.dateOfBirth_Txt.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd yyyy"
            self.dateOfBirth_Txt.text = "\(dateFormatter.string(from: datePicker.date))"
        }
        self.dateOfBirth_Txt.resignFirstResponder()
    }
    @IBAction func backBtnClick(_ sender: Any) {
        //self.navigationController?.popViewController(animated: true)
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let window: UIWindow? = (UIApplication.shared.delegate?.window)!
//        window?.rootViewController = mainStoryboard.instantiateInitialViewController()
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func profileBtnClick(_ sender: Any) {
        let validation = self.validateFields()
        if validation.isValidated == true {
            var requestDict = [String: String]()
            requestDict["EmailId"] = email_Txt.text
            ApiCall(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.chekingMailId.Api, successCallback: {(result) in
                if let results = result {
                    let result = results["Result"] as! NSNumber
                    let str = results["Message"] as! String
                    if(result == 1){
                        self.validationStr = "2st"
                        self.stackView1.isHidden = true
                        self.stackView2.isHidden = false
                        self.view.endEditing(true)
                    }else{
                       self.customViews.loadingData(titleLabl: "", subTitleLabel: str, cancelBtnTitle: "Okay", okayBtnTitle: "")
                        self.view.addSubview(self.customViews)
                    }
                }
            }, failureCallback: {(error) in
                self.customViews.loadingData(titleLabl: "", subTitleLabel: errorMessages, cancelBtnTitle: "Okay", okayBtnTitle: "")
                self.view.addSubview(self.customViews)
            })
        }else{
            self.customViews.loadingData(titleLabl: "", subTitleLabel: validation.validationMessage, cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(customViews)
        }
    }
    @IBAction func goalBtnClick(_ sender: Any) {
        stackView1.isHidden = true
        stackView2.isHidden = true
        stackView3.isHidden = false
    }
    @IBAction func createAccountBtnClick(_ sender: Any) {
        if(isBtnSelected == "Y"){
            if((companyName_Txt.text!.isEmpty && employerCode_Txt.text!.isEmpty && secureCode_Txt.text!.isEmpty)){
                alertViewValidation = "Okay Procced"
                customViews.loadingData(titleLabl: "", subTitleLabel: "You did not enter any employer information.\n\nWe will not be able to provide you with any plan information.\nDo you still want to proceed?", cancelBtnTitle: "Cancel", okayBtnTitle: "Proceed")
                self.view.addSubview(customViews)
            }else{
                var requestDict = [String: String]()
                requestDict["Company"] = companyName_Txt.text
                requestDict["Promocode"] = employerCode_Txt.text
                requestDict["WINBenefits"] = isBtnSelected
                requestDict["SecureCode"] = secureCode_Txt.text
                requestDict["EmailID"] = email_Txt.text
                ApiCall(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.loadEmployerDetails.Api, successCallback: {(results) in
                    if  let datastring = results {
                        if    datastring["EmployerMessage"]! as! String != "" {
                            self.alertViewValidation = "Okay Procced"
                            self.customViews.loadingData(titleLabl: "", subTitleLabel: datastring["EmployerMessage"] as! String, cancelBtnTitle: "Cancel", okayBtnTitle: "Proceed")
                            self.view.addSubview(self.customViews)
                        }else{
                            self.createAccount()
                        }
                    }
                }, failureCallback: {(error) in
                    self.customViews.loadingData(titleLabl: "", subTitleLabel: errorMessages, cancelBtnTitle: "Okay", okayBtnTitle: "")
                    self.view.addSubview(self.customViews)
                })
            }
        }else{
            createAccount()
        }
    }
    @IBAction func firstSwitchBtnClick(_ sender: Any) {
        if (firstSwitch.isOn){
            goalsData[0].append(contentsOf: "I want to track my cycle")
        }else{
            goalsData[0].append(contentsOf: "")
        }
    }
    @IBAction func secondSwitchBtnClick(_ sender: Any) {
        if(secondSwitch.isOn){
            goalsData[1].append(contentsOf: "I want to freeze my eggs/sperm")
        }else{
            goalsData[1].append(contentsOf: "")
        }
    }
    @IBAction func thirdSwitchBtnClick(_ sender: Any) {
        if(thirdSwitch.isOn){
            goalsData[2].append(contentsOf: "I want to get pregnant")
        }else{
            goalsData[2].append(contentsOf: "")
        }
    }
    @IBAction func fourthSwitchBtnClick(_ sender: Any) {
        if(fourthswitch.isOn){
            goalsData[3].append(contentsOf: "I am considering/undergoing fertility treatment")
        }else{
            goalsData[3].append(contentsOf: "")
        }
    }
    @IBAction func fivthSwitchBtnClick(_ sender: Any) {
        if(fivthSwitch.isOn){
            goalsData[4].append(contentsOf: "My partner is considering/undergoing fertility treatment")
        }else{
            goalsData[4].append(contentsOf: "")
        }
    }
    @IBAction func sixthSwitchBtnClick(_ sender: Any) {
        if(sixthSwitch.isOn){
            goalsData[5].append(contentsOf: "I am interested in surrogacy or adoption")
        }else{
            goalsData[5].append(contentsOf: "")
        }
    }
    @IBAction func enableEmployerSwitchAction(_ sender: Any) {
        if(employerSwitch.isOn){
            stackView5.isHidden = false
            isBtnSelected = "Y"
        }else{
            stackView5.isHidden = true
            isBtnSelected = "N"
        }
    }
    func createAccount(){
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let strings = goalsData.filter{$0 != ""}
        let goalText = strings.joined(separator: ",")
        var requestDict             = [String: String]()
        requestDict["FirstName"]    = firstName_Txt.text
        requestDict["LastName"]     = lastName_Txt.text
        requestDict["EmailID"]      = email_Txt.text
        requestDict["PhoneNo"]      = phoneNumber_Txt.text
        requestDict["DOB"]          = Utils.getStringFromDate(date: Utils.getDateFromString(dateStr: dateOfBirth_Txt.text!, format: "MMM dd yyyy"), format: "MM/dd/yyyy")
        requestDict["Company"]      = companyName_Txt.text
        requestDict["Gender"]       = gender_Txt.text
        requestDict["Promocode"]    = employerCode_Txt.text
        requestDict["SecureCode"]   = secureCode_Txt.text
        requestDict["WINBenefits"]  = isBtnSelected
        requestDict["Goal"]         = goalText
        requestDict["DeviceType"] = "iOS"
        requestDict["UpdateFlag"] = "N"
        requestDict["PWD"] = createPassword_Txt.text
        requestDict["Version"] = appVersion
        print(requestDict)
        ApiCall(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.createAccount.Api, successCallback: {(result) in
            let loginData = logindata(json: result!)
            print(loginData.result!)
            if(LoadLoginData.result! == 2){
                if (UserDefaults.standard.bool(forKey: UserDefaultsStored.UserLogedInOrNot)){
                    requestAutToken()
                }else{
                    UserDefaults.standard.set(true, forKey: UserDefaultsStored.UserLogedInOrNot)
                    UserDefaults.standard.set(self.email_Txt.text!, forKey: UserDefaultsStored.emailID)
                    UserDefaults.standard.set(self.confirmPassword_Txt.text!, forKey: UserDefaultsStored.password)
                    requestAutToken()
                }
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                self.navigationController?.pushViewController(vc!, animated: true)
            }else{
               // self.errorMessage_Lbl.text = LoadLoginData.message!
                self.customViews.loadingData(titleLabl: "", subTitleLabel: errorMessages, cancelBtnTitle: "Okay", okayBtnTitle: "")
                self.view.addSubview(self.customViews)
            }
        }, failureCallback: {(error) in
            self.customViews.loadingData(titleLabl: "", subTitleLabel: errorMessages, cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(self.customViews)
        })
    }
}
extension CreateAccountViewController {
    func validateFields() -> (isValidated:Bool, validationMessage:String) {
        
        var isValidated = true
        var validationMssg = ""
        
        if firstName_Txt.text == "" {
            isValidated    = false
            validationMssg = AppConstants.AlertMessage.enterFName.rawValue
        }
        else if lastName_Txt.text == "" {
            isValidated = false
            validationMssg = AppConstants.AlertMessage.enterLName.rawValue
        }
        else if email_Txt.text == "" {
            isValidated = false
            validationMssg = AppConstants.AlertMessage.enterEmail.rawValue
        }
        else if (!validateEmail(email: email_Txt.text!)) {
            isValidated = false
            validationMssg = AppConstants.AlertMessage.validEmail.rawValue
        }
        else if createPassword_Txt.text == "" {
            isValidated = false
            validationMssg = AppConstants.AlertMessage.enterPassword.rawValue
        }
        else if createPassword_Txt.text != "" && !isPasswordValid(createPassword_Txt.text!) {
            isValidated = false
            validationMssg = AppConstants.AlertMessage.validPassword.rawValue
        }
        else if confirmPassword_Txt.text == "" {
            isValidated = false
            validationMssg = AppConstants.AlertMessage.enterConfPwd.rawValue
        }
        else if(createPassword_Txt.text != confirmPassword_Txt.text) {
            isValidated = false
            validationMssg = AppConstants.AlertMessage.pwdMismatch.rawValue
        }
        return (isValidated, validationMssg)
    }
}
extension CreateAccountViewController {
    func cancelBtnAction(sender: AnyObject) {
        self.customViews.removeFromSuperview()
    }
    func okayBtnAction(sender: AnyObject) {
        if(alertViewValidation == "Okay Procced"){
            createAccount()
        }
        self.customViews.removeFromSuperview()
    }
}
