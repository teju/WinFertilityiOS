//
//  ExportNotesViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 31/01/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit

class ExportNotesViewController: UIViewController, customViewDelegate {
    
    

    @IBOutlet weak var startDate_Txt: ZWTextField!
    @IBOutlet weak var endDate_Txt: ZWTextField!
    @IBOutlet weak var tabbar: UITabBar!
    var popUpValidator = ""
    var customViews = CustomView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customViews.customViewDelegates = self
        let today = Date()
        let thirtyDaysBeforeToday = Calendar.current.date(byAdding: .day, value: -30, to: today)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        endDate_Txt.text = dateFormatter.string(from: today)
        startDate_Txt.text = dateFormatter.string(from: thirtyDaysBeforeToday)
        
        startDate_Txt.addInputViewDatePicker(target: self, selector: #selector(startDatedoneButtonPressed), maxDate: Date(), minDate: Date.from(year: 2014, month: 01, day: 01),datePickerMode: .date)
        endDate_Txt.addInputViewDatePicker(target: self, selector: #selector(endDatedoneButtonPressed), maxDate: Date(), minDate: Date.from(year: 2014, month: 01, day: 01), datePickerMode: .date)
        
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
    func cancelBtnAction(sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func okayBtnAction(sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
        self.customViews.removeFromSuperview()
    }
    @objc func startDatedoneButtonPressed() {
       if let  datePicker = self.startDate_Txt.inputView as? UIDatePicker {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "dd MMM yyyy"
           self.startDate_Txt.text = dateFormatter.string(from: datePicker.date)
       }
       self.startDate_Txt.resignFirstResponder()
    }
    @objc func endDatedoneButtonPressed() {
       if let  datePicker = self.startDate_Txt.inputView as? UIDatePicker {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "dd MMM yyyy"
           self.endDate_Txt.text = dateFormatter.string(from: datePicker.date)
       }
       self.endDate_Txt.resignFirstResponder()
    }
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func exportNotesBtnClick(_ sender: Any) {
        exportNote()
    }
    func exportNote(){
       var responceDict = [String: String]()
        responceDict["EmailID"] = LoadLoginData.emailID
        responceDict["ToEmailID"] = LoadLoginData.emailID
        responceDict["Duration"] = ""
        responceDict["fromDate"] = Utils.getStringFromDate(date: Utils.getDateFromString(dateStr: startDate_Txt.text!, format: "dd MMM yyyy"), format: "MM/dd/yyyy")
        responceDict["toDate"] = Utils.getStringFromDate(date: Utils.getDateFromString(dateStr: endDate_Txt.text!, format: "dd MMM yyyy"), format: "MM/dd/yyyy")
        ApiCall(requestDict: responceDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.sendMyGraphs.Api, successCallback: {(result) in
            self.customViews.loadingData(titleLabl: "", subTitleLabel: "\(AppConstants.AlertMessage.emailChartSuccess.rawValue)", cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(self.customViews)
        }, failureCallback: {(error) in
            self.customViews.loadingData(titleLabl: "", subTitleLabel: "\(AppConstants.AlertMessage.genericError)", cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(self.customViews)
        })
    }
}
