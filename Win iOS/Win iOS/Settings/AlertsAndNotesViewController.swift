//
//  AlertsAndNotesViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 04/02/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

var reminderID = ""
var reminderDate = ""
var notesData = NSDictionary()

import UIKit

class AlertsAndNotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, customViewDelegate {
    func cancelBtnAction(sender: AnyObject) {
        self.customViews.removeFromSuperview()
    }
    
    func okayBtnAction(sender: AnyObject) {
        deleteReminderID()
        self.customViews.removeFromSuperview()
    }
    
    
    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var title_Lbl: UILabel!
    @IBOutlet weak var notesTableView: UITableView!
    @IBOutlet weak var alertsTableview: UITableView!
    @IBOutlet weak var notesTitleSatckView: UIStackView!
    @IBOutlet weak var alertsTitleStackView: UIStackView!
    
    var alertsData = NSMutableArray()
    var eventData = NSMutableArray()
    var reminders = [[String: String]]()
    
    var alertMessage = ""
    var notesMessage = ""
    var indexValue = Int()
    var customViews = CustomView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customViews.customViewDelegates = self
        notesData = [:]
        if let selDate = selectedDateNotes {
            let date1 = Utils.getStringFromDate(date: selDate, format: "EEEE, MMM dd, yyyy")
            title_Lbl.text = date1
        }
        if(dateValidator == "fetureDate"){
            notesTitleSatckView.isHidden = true
        }else if(dateValidator == "pastDate"){
            alertsTitleStackView.isHidden = true
        }else if(dateValidator == "toDay"){
            
        }else{
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.reminders.removeAll()
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
        reminderID = ""
        loadReminderEventData()
    }
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func notesAddBtnClick(_ sender: Any) {
    
    }
    @IBAction func alertsBtnClick(_ sender: Any) {
    }
    @objc func deleteBtnClick(sender: UIButton){
        
         indexValue = sender.tag
        self.customViews.loadingData(titleLabl: "", subTitleLabel: "Are you want delete reminder?", cancelBtnTitle: "Cancel", okayBtnTitle: "Okay")
        self.view.addSubview(self.customViews)
      
    }
    func deleteReminderID(){
        var requestDict = [String: Any]()
               requestDict["ReminderID"] = reminders[indexValue]["ReminderID"]!
               ApiCall(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.deleteReminders.Api, successCallback: {(result) in
                self.reminders.removeAll()
                   self.loadReminderEventData()
               }, failureCallback: {(error) in
                   self.customViews.loadingData(titleLabl: "", subTitleLabel: "\(AppConstants.AlertMessage.genericError)", cancelBtnTitle: "Okay", okayBtnTitle: "")
                   self.view.addSubview(self.customViews)
               })
    }
    func loadReminderEventData(){
        var requestDict = [String: String]()
        requestDict["EmailID"] = LoadLoginData.emailID
        if let selDate = selectedDateNotes {
            requestDict["Date"] = Utils.getStringFromDate(date: selDate, format: "MM/dd/yyyy")
        }
        ApiCall(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.loadReminderEventData.Api, successCallback: {(result) in
            if let dataResult = result {
                if let eventDataResult = dataResult["Events"] {
                    notesData = eventDataResult as! NSDictionary
                    self.eventData.removeAllObjects()
                    if let eventDate = eventDataResult.value(forKey: "EventDate") as? String, !eventDate.isEmpty{

                    }
                    if let EventID = eventDataResult.value(forKey: "EventID") as? String, !EventID.isEmpty {
                        
                    }else{
                        self.notesMessage = "No notes recorded for this date."
                    }
                    if let Medications = eventDataResult.value(forKey: "Medications") as? String, !Medications.isEmpty {
                        let formattedString = NSMutableAttributedString()
                        self.eventData.add(formattedString.bolds("Medications: ").normals(Medications))
                    }
                    if let Mood = eventDataResult.value(forKey: "Mood") as? String, !Mood.isEmpty {
                        let formattedString = NSMutableAttributedString()
                        self.eventData.add(formattedString.bolds("Mood: ").normals(Mood))
                    }
                    if let Notes = eventDataResult.value(forKey: "Notes") as? String, !Notes.isEmpty {
                        let formattedString = NSMutableAttributedString()
                        self.eventData.add(formattedString.bolds("Notes: ").normals(Notes))
                    }
                    if let OvulationTests = eventDataResult.value(forKey: "OvulationTests") as? String, !OvulationTests.isEmpty {
                        let formattedString = NSMutableAttributedString()
                        self.eventData.add(formattedString.bolds("OvulationTests: ").normals(OvulationTests))
                    }
                    if let Period = eventDataResult.value(forKey: "Period") as? String, !Period.isEmpty {
                        let formattedString = NSMutableAttributedString()
                        self.eventData.add(formattedString.bolds("Period: ").normals(Period))
                    }
                    if let PersonalSymptoms = eventDataResult.value(forKey: "PersonalSymptoms") as? String, !PersonalSymptoms.isEmpty {
                        let formattedString = NSMutableAttributedString()
                        self.eventData.add(formattedString.bolds("PersonalSymptoms: ").normals(PersonalSymptoms))
                    }
                    if let PregnancyTests = eventDataResult.value(forKey: "PregnancyTests") as? String, !PregnancyTests.isEmpty {
                        let formattedString = NSMutableAttributedString()
                        self.eventData.add(formattedString.bolds("PregnancyTests: ").normals(PregnancyTests))
                    }
                    if let SexDrive = eventDataResult.value(forKey: "SexDrive") as? String, !SexDrive.isEmpty {
                        let formattedString = NSMutableAttributedString()
                        self.eventData.add(formattedString.bolds("SexDrive: ").normals(SexDrive))
                    }
                    if let SexualActivity = eventDataResult.value(forKey: "SexualActivity") as? String, !SexualActivity.isEmpty {
                        let formattedString = NSMutableAttributedString()
                        self.eventData.add(formattedString.bolds("SexualActivity: ").normals(SexualActivity))
                    }
                    self.notesTableView.reloadData()
                }
                if let alertDataResult = dataResult["Reminders"] as? [[String: String]]{
                    let reminderss = alertDataResult
                    if !((reminderss[0]["ReminderID"])!.isEmpty){
                    self.reminders = alertDataResult
                    self.alertsTableview.reloadData()
                    }else{
                        self.alertMessage = "No alerts to display for this date."
                        self.alertsTableview.reloadData()
                    }
                }else{
                    self.alertMessage = "No alerts to display for this date."
                    self.alertsTableview.reloadData()
                }
            }else{
                
            }
        }, failureCallback: { (error) in
            self.customViews.loadingData(titleLabl: "", subTitleLabel: "\(AppConstants.AlertMessage.genericError)", cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(self.customViews)
        })
    }
}
extension AlertsAndNotesViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == notesTableView {
            if eventData.count == 0 {
                self.notesTableView.showEmptyListMessage("\(notesMessage)")
            }else{
                self.notesTableView.showEmptyListMessage("")
            }
            return eventData.count
        }else if tableView == alertsTableview {
            if reminders.count == 0 {
                self.alertsTableview.showEmptyListMessage("\(alertMessage)")
            }else{
                self.alertsTableview.showEmptyListMessage("")
            }
            return reminders.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        if tableView == notesTableView{
            cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell1")!
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.attributedText = eventData[indexPath.row] as? NSAttributedString
        } else if tableView == alertsTableview  {
            let tableCell: AlertsTableViewCell = (tableView.dequeueReusableCell(withIdentifier:"AlertsCell1", for: indexPath) as? AlertsTableViewCell)!
            tableCell.title_Lbl.text = reminders[indexPath.row]["ReminderTitle"]!
            let startTime = Utils.getStringFromDate(date: Utils.getDateFromString(dateStr: reminders[indexPath.row]["StartTime"]!, format: "yyyy-MM-dd'T'HH:mm:ss"), format: "HH:mm")
            let endTime = Utils.getStringFromDate(date: Utils.getDateFromString(dateStr: reminders[indexPath.row]["EndTime"]!, format: "yyyy-MM-dd'T'HH:mm:ss"), format: "HH:mm")
            tableCell.DiscripptionLbl.text = "\(startTime) - \(endTime)"
            tableCell.deleteBtnClick.tag = indexPath.row
            tableCell.deleteBtnClick.addTarget(self,action:#selector(deleteBtnClick(sender:)), for: .touchUpInside)
            return tableCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == notesTableView){
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
            self.navigationController?.pushViewController(loginVC, animated: true)
        }else{
            reminderID = reminders[indexPath.row]["ReminderID"]!
            reminderDate = reminders[indexPath.row]["ReminderDate"]!
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlertsViewController") as! AlertsViewController
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
    }
}
class AlertsTableViewCell: UITableViewCell {
    @IBOutlet weak var title_Lbl: UILabel!
    @IBOutlet weak var DiscripptionLbl: UILabel!
    @IBOutlet weak var deleteBtnClick: UIButton!
}
