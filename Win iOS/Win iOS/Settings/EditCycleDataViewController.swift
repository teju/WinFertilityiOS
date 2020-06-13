//
//  EditCycleDataViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 31/01/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit

class EditCycleDataViewController: UIViewController, ToolbarPickerViewDelegate, UITextFieldDelegate, customViewDelegate {
    
    func didTapDone() {
        self.view.endEditing(true)
    }
    func didTapCancel() {
        self.view.endEditing(true)
    }
    

    @IBOutlet weak var periodStartDate_Txt: ZWTextField!
    @IBOutlet weak var periodLast_Txt: ZWTextField!
    @IBOutlet weak var cycle_Txt: ZWTextField!
    @IBOutlet weak var tabbar: UITabBar!
    var customViews = CustomView()
    override func viewDidLoad() {
        super.viewDidLoad()
        customViews.customViewDelegates = self
        periodStartDate_Txt.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed), maxDate: Date(), minDate: Date.from(year: 2014, month: 01, day: 01), datePickerMode: .date)
        periodLast_Txt.loadDropdownData(data: randomString(startInt: 1, endInt: 10))
        cycle_Txt.loadDropdownData(data: randomString(startInt: 18, endInt: 90))
    }
    override func viewWillAppear(_ animated: Bool) {
        if(LoadLoginData.contractIdentified == "PWC"){
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
        presentIndex = "5"
        self.tabbar.selectedItem = tabbar.items?[4]
        }
       LoadData()
    }
   @objc func doneButtonPressed() {
        if let  datePicker = self.periodStartDate_Txt.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            self.periodStartDate_Txt.text = dateFormatter.string(from: datePicker.date)
        }
        self.periodStartDate_Txt.resignFirstResponder()
     }
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func saveBtnClick(_ sender: Any) {
        let valid = validation()
        if(valid.1){
        saveCycleData()
        }else{
            print("Not Valid")
        }
    }
    func cancelBtnAction(sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
       }
       
       func okayBtnAction(sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
        self.customViews.removeFromSuperview()
       }
    func validation() -> (String, Bool){
        var validationString = ""
        var validOrNot = true
        guard !periodStartDate_Txt.text!.isEmpty else {
            validationString = errorMessage.loginEmptyEmailID_Msg.rawValue
            validOrNot = false
            return (validationString, validOrNot)
        }
        guard !periodLast_Txt.text!.isEmpty else {
            validationString = errorMessage.loginEmptyPassword_Msg.rawValue
            validOrNot = false
            return (validationString, validOrNot)
        }
        guard !cycle_Txt.text!.isEmpty else {
            validationString = errorMessage.loginWorngEmailID_Msg.rawValue
            validOrNot = false
            return (validationString, validOrNot)
        }
        return (validationString, validOrNot)
    }
    func LoadData(){
        var responceDict = [String:String]()
        responceDict["EmailID"] = LoadLoginData.emailID
        ApiCall(requestDict: responceDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.loadCycleData.Api, successCallback: {(result) in
            if result != nil {
                self.periodStartDate_Txt.text = Utils.getStringFromDate(date: Utils.getDateFromString(dateStr: (result!["CycleStartDate"] as? String)!, format: "yyyy-MM-dd"), format: "MMM dd,yyyy")
                self.periodLast_Txt.text = result!["LastPeriodDays"] as? String
                self.cycle_Txt.text = result!["CycleDays"] as? String
            }else{
                print("data not available")
                self.customViews.loadingData(titleLabl: "", subTitleLabel: errorMessages, cancelBtnTitle: "Okay", okayBtnTitle: "")
                self.view.addSubview(self.customViews)
            }
        }, failureCallback: {(error) in
            self.customViews.loadingData(titleLabl: "", subTitleLabel: errorMessages, cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(self.customViews)
        })
    }
    func saveCycleData(){
        var responceDict = [String:String]()
        responceDict["CycleDays"] = self.cycle_Txt.text!
        responceDict["LastPeriodDays"] = self.periodLast_Txt.text!
        responceDict["CycleStartDate"] = Utils.getStringFromDate(date: Utils.getDateFromString(dateStr: self.periodStartDate_Txt.text!, format: "MMM dd,yyyy"), format: "yyyy-MM-dd")
        responceDict["EmailID"] = LoadLoginData.emailID
        print(responceDict)
               ApiCall(requestDict: responceDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.saveMenstrualCycle.Api, successCallback: {(result) in
                   if result != nil {
                    self.customViews.loadingData(titleLabl: "", subTitleLabel: "Successfully updated the data!", cancelBtnTitle: "Okay", okayBtnTitle: "")
                    self.view.addSubview(self.customViews)
                   }else{
                       self.customViews.loadingData(titleLabl: "", subTitleLabel: "Successfully updated the data!", cancelBtnTitle: "Okay", okayBtnTitle: "")
                       self.view.addSubview(self.customViews)
                   }
               }, failureCallback: {(error) in
                   self.customViews.loadingData(titleLabl: "", subTitleLabel: "\(AppConstants.AlertMessage.genericError)", cancelBtnTitle: "Okay", okayBtnTitle: "")
                   self.view.addSubview(self.customViews)
               })
    }
}

