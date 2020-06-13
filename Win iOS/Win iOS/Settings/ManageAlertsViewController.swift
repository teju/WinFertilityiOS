//
//  ManageAlertsViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 30/01/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit

class ManageAlertsViewController: UIViewController {
    
    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var enbleNotificationSwitch: UISwitch!
    @IBOutlet weak var NotificationTableView: UITableView!
    
    var notifications = NSArray()
    var emptyTableView = ""
    
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
        openedNotification = false
        if(LoadLoginData.notificationStatus == "No"){
            enbleNotificationSwitch.isOn = false
        }else{
            enbleNotificationSwitch.isOn = true
        }
        loadNotificationData()
        twilioTokenId = ""
    }
    override func viewWillAppear(_ animated: Bool) {
        presentIndex = "6"
        self.tabbar.selectedItem = tabbar.items?[5]
    }
    @IBAction func enableNotificationSwitchAction(_ sender: Any) {
        loadNotificationDataStatus()
    }
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func loadNotificationData(){
        var responseDict = [String: String]()
        responseDict["EmailID"] = LoadLoginData.emailID
        ApiCalls(requestDict: responseDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.loadNotificationList.Api, successCallback: {(result) in
            if result.count > 0 {
                self.notifications = result
            }else{
                self.emptyTableView = "You don't have any notification to show."
            }
            self.NotificationTableView.reloadData()
        }, failureCallback: {(error) in
            
        })
    }
    func loadNotificationDataStatus() {
        var responseDict = [String: String]()
        responseDict["EmailID"] = LoadLoginData.emailID
        if (enbleNotificationSwitch.isOn){
            responseDict["NotificationStatus"] = "Yes"
        }else{
            responseDict["NotificationStatus"] = "No"
        }
        ApiCall(requestDict: responseDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.saveNotificarionStatus.Api, successCallback: {(result) in
            if result != nil {
                print(self.notifications.count)
            }
        }, failureCallback: {(error) in
            
        })
    }
    
}
extension ManageAlertsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (notifications.count > 0){
           return notifications.count
        }else{
            self.NotificationTableView.showEmptyListMessage("\(String(describing: emptyTableView))")
        }
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let eventCell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationTableViewCell
        let noti  = self.notifications[indexPath.row] as! NSDictionary
        eventCell.title_Lbl.text = noti.value(forKey: "NotificationHeader") as? String
        eventCell.subTitle_Lbl.text = "\"\(noti.value(forKey: "NotificationBody") as! String)\""
        eventCell.date_Lbl.text = "- \(noti.value(forKey: "NotificationDate") as! String)"
        return eventCell
    }
}

class NotificationTableViewCell: UITableViewCell {
    @IBOutlet weak var title_Lbl: UILabel!
    @IBOutlet weak var subTitle_Lbl: UILabel!
    @IBOutlet weak var date_Lbl: UILabel!
    
}
