//
//  AlertsViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 04/02/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit

class AlertsViewController: UIViewController, customViewDelegate, UITextViewDelegate {
    
    func cancelBtnAction(sender: AnyObject) {
        okaybuttonValidation = false
        self.customViews.removeFromSuperview()
    }
    
    func okayBtnAction(sender: AnyObject) {
        if(okaybuttonValidation){
            deleteReminderID()
        }
        self.customViews.removeFromSuperview()
    }
    var okaybuttonValidation = Bool()
    @IBOutlet weak var reminderTitle_Txt: ZWTextField!
    @IBOutlet weak var type_Txt: ZWTextField!
    @IBOutlet weak var startTime_Txt: ZWTextField!
    @IBOutlet weak var endTime_Txt: ZWTextField!
    @IBOutlet weak var remindMeBefore_Txt: ZWTextField!
    @IBOutlet weak var repeat_Txt: ZWTextField!
    @IBOutlet weak var notes_TextView: UITextView!
    
    @IBOutlet weak var sendAMail_switch: UISwitch!
    @IBOutlet weak var allDay_switch: UISwitch!
    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var deleteBtnOutlet: UIButton!
    
    
    let dateFormatter123 = DateFormatter()
    
    var typeArr = ["Select","Doctor’s Appointment","Receive Medication","Appointment Reminder","Log Event Reminder","Check Personal Symptoms Reminder","Other"]
    var remindMeBeforeArr = ["On Time","5 Minutes","10 Minutes","15 Minutes","30 Minutes","45 Minutes","1 Hour","1 Day"]
    var remindMeBeforeValueArr = ["0","5","10","15","30","45","60","1440"]
    var repeatArr = ["Never", "Every Day", "Every Week", "Every 2 Weeks", "Every Month", "Every Year"]
    var repeatArrindexValue = ["0","1","7","14","30","365"]
    let startTime = Calendar.current.startOfDay(for: selectedDateNotes!)
    let endTime = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: selectedDateNotes!)
    
     var customViews = CustomView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        okaybuttonValidation = false
        self.deleteBtnOutlet.isHidden = true
        
        customViews.customViewDelegates = self
        dateFormatter123.dateFormat = "MMM dd yyyy"
        type_Txt.loadDropdownData(data: typeArr)
        remindMeBefore_Txt.loadDropdownData(data: remindMeBeforeArr)
        repeat_Txt.loadDropdownData(data: repeatArr)
        startTime_Txt.addInputViewDatePicker(target: self, selector: #selector(startTimedoneButtonPressed), maxDate: startTime, minDate: endTime, datePickerMode: .time)
        endTime_Txt.addInputViewDatePicker(target: self, selector: #selector(endTimedoneButtonPressed), maxDate: endTime, minDate: startTime, datePickerMode: .time)
        startTime_Txt.text = Utils.getStringFromDate(date: selectedDateNotes!, format: "MMM dd yyyy hh:mm a")
        endTime_Txt.text = Utils.getStringFromDate(date: Calendar.current.date(byAdding: .minute, value: 30, to: selectedDateNotes!)!, format: "MMM dd yyyy hh:mm a")
        notes_TextView.text = "Text of reminder"
        notes_TextView.textColor = UIColor.lightGray
        notes_TextView.delegate = self
        if !(reminderID.isEmpty){
            self.deleteBtnOutlet.isHidden = false
            loadReminder()
        }
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
    }
    @objc func startTimedoneButtonPressed() {
       if let  datePicker = self.startTime_Txt.inputView as? UIDatePicker {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "hh:mm a"
        self.startTime_Txt.text = "\(dateFormatter123.string(from: selectedDateNotes!)) \(dateFormatter.string(from: datePicker.date))"
            self.endTime_Txt.addInputViewDatePicker(target: self, selector: #selector(endTimedoneButtonPressed), maxDate: endTime, minDate: Utils.getDateFromString(dateStr: "\(dateFormatter123.string(from: selectedDateNotes!)) \(dateFormatter.string(from: datePicker.date))", format: "MMM dd yyyy hh:mm a"), datePickerMode: .time)
       }
       self.startTime_Txt.resignFirstResponder()
    }
    @objc func endTimedoneButtonPressed() {
          if let  datePicker = self.endTime_Txt.inputView as? UIDatePicker {
              let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "hh:mm a"
              self.endTime_Txt.text = "\(dateFormatter123.string(from: selectedDateNotes!)) \(dateFormatter.string(from: datePicker.date))"
            endTime_Txt.addInputViewDatePicker(target: self, selector: #selector(endTimedoneButtonPressed), maxDate: Utils.getDateFromString(dateStr: "\(dateFormatter123.string(from: selectedDateNotes!)) \(dateFormatter.string(from: datePicker.date))", format: "MMM dd yyyy hh:mm a"), minDate: endTime, datePickerMode: .time)
          }
          self.endTime_Txt.resignFirstResponder()
       }
    @IBAction func allDaySwitchAction(_ sender: Any) {
        if (allDay_switch.isOn){
            startTime_Txt.isUserInteractionEnabled = false
            endTime_Txt.isUserInteractionEnabled = false
            startTime_Txt.text = Utils.getStringFromDate(date: startTime, format: "MMM dd yyyy hh:mm a")
            endTime_Txt.text = Utils.getStringFromDate(date: endTime!, format: "MMM dd yyyy hh:mm a")
        }else{
            startTime_Txt.isUserInteractionEnabled = true
            endTime_Txt.isUserInteractionEnabled = true
            startTime_Txt.text = Utils.getStringFromDate(date: startTime, format: "MMM dd yyyy hh:mm a")
            endTime_Txt.text = Utils.getStringFromDate(date: endTime!, format: "MMM dd yyyy hh:mm a")
        }
    }
    @IBAction func sendAReminderByMailSwitchAction(_ sender: Any) {
    }
    
    @IBAction func deleteBntCliked(_ sender: Any) {
        okaybuttonValidation = true
        self.customViews.loadingData(titleLabl: "", subTitleLabel: "Are you want delete reminder?", cancelBtnTitle: "Cancel", okayBtnTitle: "Okay")
        self.view.addSubview(self.customViews)
    }
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func saveBtnClick(_ sender: Any) {
        if(reminderTitle_Txt.text == ""){
            self.customViews.loadingData(titleLabl: "", subTitleLabel: "Please enter reminder title.", cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(self.customViews)
        }else if(type_Txt.text == "Select"){
            self.customViews.loadingData(titleLabl: "", subTitleLabel: "Please select reminder type.", cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(self.customViews)
        }else{
            saveReminder()
        }
    }
    func deleteReminderID(){
        var requestDict = [String: Any]()
               requestDict["ReminderID"] = reminderID
               ApiCall(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.deleteReminders.Api, successCallback: {(result) in
                self.navigationController?.popViewController(animated: true)
               }, failureCallback: {(error) in
                self.okaybuttonValidation = false
                   self.customViews.loadingData(titleLabl: "", subTitleLabel: "\(AppConstants.AlertMessage.genericError)", cancelBtnTitle: "Okay", okayBtnTitle: "")
                   self.view.addSubview(self.customViews)
               })
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Text of reminder"
            textView.textColor = UIColor.lightGray
        }
    }
    func loadReminder(){
        var requestDict = [String: String]()
        requestDict["EmailID"] = LoadLoginData.emailID
        requestDict["ReminderID"] = reminderID
        requestDict["Date"] = reminderDate
        ApiCall(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.loadReminders.Api, successCallback: {(results) in
            if let dataresult = results {
                if dataresult["AllDay"] as! String == "No"{
                    self.allDay_switch.setOn(false, animated: true)
                }else{
                    self.allDay_switch.setOn(true, animated: true)
                }
                self.endTime_Txt.text = Utils.getStringFromDate(date: Utils.getDateFromString(dateStr: dataresult["EndTime"] as! String, format: "yyyy-MM-dd'T'HH:mm:ss"), format: "MMM dd yyyy hh:mm a")
                self.startTime_Txt.text = Utils.getStringFromDate(date: Utils.getDateFromString(dateStr: dataresult["StartTime"] as! String, format: "yyyy-MM-dd'T'HH:mm:ss"), format: "MMM dd yyyy hh:mm a")
                self.reminderTitle_Txt.text = dataresult["ReminderTitle"] as? String ?? ""
                self.type_Txt.text = dataresult["ReminderType"] as? String ?? ""
                let repeatText = dataresult["Repeat"]  as? String ?? "0"
                let remindmebefore = dataresult["RemindBefore"]  as? Int ?? 0
                let remindMeBeforeIndexs = self.remindMeBeforeValueArr.firstIndex(of: "\(remindmebefore)")
                self.remindMeBefore_Txt.text = self.remindMeBeforeArr[remindMeBeforeIndexs!]
                let repeatIndexs = self.repeatArrindexValue.firstIndex(of: "\(repeatText)")
                self.repeat_Txt.text = self.repeatArr[repeatIndexs!]
                if(dataresult["TextOfReminder"] as? String != ""){
                self.notes_TextView.text = dataresult["TextOfReminder"] as? String ?? ""
                    self.notes_TextView.textColor = UIColor.black
                }else{
                    self.notes_TextView.text = "Text of reminder"
                    self.notes_TextView.textColor = UIColor.lightGray
                    self.notes_TextView.delegate = self
                }
            }else{
                
            }
        }, failureCallback: {(error) in
            self.customViews.loadingData(titleLabl: "", subTitleLabel: errorMessages, cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(self.customViews)
        })
    }
    func saveReminder(){
        var notesstr = ""
        if(notes_TextView.text == "Test of reminder"){
            notesstr = ""
        }else{
            notesstr = notes_TextView.text
        }
        let startDate = Utils.getStringFromDate(date: Utils.getDateFromString(dateStr: startTime_Txt.text!, format: "MMM dd yyyy hh:mm a"), format: "yyyy-MM-dd'T'HH:mm:ss")
        let endDate = Utils.getStringFromDate(date: Utils.getDateFromString(dateStr: endTime_Txt.text!, format: "MMM dd yyyy hh:mm a"), format: "yyyy-MM-dd'T'HH:mm:ss")
        var requestDict = [String: Any]()
        let remindMeBeforeIndex = remindMeBeforeArr.firstIndex(of: remindMeBefore_Txt.text!)
        let repeatIndex = repeatArr.firstIndex(of: repeat_Txt.text!)
        
        requestDict["EmailID"]         = LoadLoginData.emailID
        requestDict["ReminderDate"]    = Utils.getStringFromDate(date: selectedDateNotes!, format: "MM/dd/yyyy")
        requestDict["StartTime"]       = startDate
        requestDict["EndTime"]         = endDate
        requestDict["ReminderTitle"]   = reminderTitle_Txt.text!
        requestDict["TextOfReminder"]  = notesstr
        requestDict["ReminderType"]    =  type_Txt.text!
        requestDict["EmailReminderTo"] = "win@app.com"
        requestDict["SetLocation"] = ""
        requestDict["RemindBefore"] = "\(remindMeBeforeValueArr[remindMeBeforeIndex!])"
        requestDict["Repeat"] = "\(repeatArrindexValue[repeatIndex!])"
        requestDict["ReminderID"] = reminderID 
        
        if allDay_switch.isOn {
            requestDict["AllDay"] = "Yes"
        }
        else {
            requestDict["AllDay"] = "No"
        }
        ApiCall(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.saveReminders.Api, successCallback: {(results) in
            print(results)
            self.navigationController?.popViewController(animated: true)
        }, failureCallback: {(error) in
            self.customViews.loadingData(titleLabl: "", subTitleLabel: "\(AppConstants.AlertMessage.genericError)", cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(self.customViews)
        })
    }
}
