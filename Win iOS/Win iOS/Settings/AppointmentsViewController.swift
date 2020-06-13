//
//  AppointmentsViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 30/01/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

var twilioTokenId = ""

import UIKit

class AppointmentsViewController: UIViewController, customViewDelegate {
    func cancelBtnAction(sender: AnyObject) {
        self.customViews.removeFromSuperview()
    }
    
    func okayBtnAction(sender: AnyObject) {
        print("Cancel btn Click")
            cancelAppointment()
        self.customViews.removeFromSuperview()
    }
    
    
    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var message_Lbl: UILabel!
    @IBOutlet weak var joinVideoCallBtnOutlet: UIButton!
     var customViews = CustomView()
    var timer:Timer?
    var scheduledAppoinmtData = [validationList]()
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
        self.message_Lbl.text = ""
        joinVideoCallBtnOutlet.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        presentIndex = "6"
        self.tabbar.selectedItem = tabbar.items?[5]
        gettingScheduledAppoint()
    }
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func joinVideoCallBtnClick(_ sender: Any) {
        if (joinVideoCallBtnOutlet.titleLabel?.text == "Cancel Appointment"){
            self.customViews.loadingData(titleLabl: "", subTitleLabel: "Are you want to cancel your appointment?", cancelBtnTitle: "No", okayBtnTitle: "Okay")
            self.view.addSubview(self.customViews)
        }else{
            gettingTwilioToken()
        }
    }
    func gettingTwilioToken(){
        var responceDict = [String: String]()
        responceDict["Room"] = scheduledAppoinmtData[0].videoRoomName
        responceDict["Name"] = scheduledAppoinmtData[0].memberID
        ApiCall(requestDict: responceDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.getTwilioToken.Api, successCallback: {(result) in
            if result != nil {
                twilioTokenId = result!["Data"] as! String
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VideoChatViewController") as? VideoChatViewController
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }, failureCallback: {(error) in
            
        })
    }
    func cancelAppointment(){
        var responseDict = [String: String]()
        responseDict["Email"] = LoadLoginData.emailID
        responseDict["Text"] = "Booked"
        responseDict["SelectedDate"] = scheduledAppoinmtData[0].selectedDate
        responseDict["Time"] = scheduledAppoinmtData[0].time
        responseDict["SlotType"] = scheduledAppoinmtData[0].slotType
        responseDict["UserName"] = "MAPP"
        ApiCall(requestDict: responseDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.saveNurseShedule.Api, successCallback: {(result) in
            if(result!["Data"] as! String == "Success"){
                  self.message_Lbl.text = "You do not have appointments scheduled yet."
                  self.joinVideoCallBtnOutlet.isHidden = true
                self.gettingScheduledAppoint()
            }
        }, failureCallback: {(error) in
            
        })
    }
    func gettingScheduledAppoint(){
        var responseDict = [String: String]()
        responseDict["Email"] = LoadLoginData.emailID
        ApiCalls(requestDict: responseDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.validationList.Api, successCallback: {(result) in
            if  result.count > 0{
            
                self.joinVideoCallBtnOutlet.isHidden = false
               for i in 0...result.count - 1 {
                    let dataObject = validationList.init(json: result[i] as! Dictionary<String, AnyObject>)
                    self.scheduledAppoinmtData.append(dataObject)
                }
                var callType = ""
                if(self.scheduledAppoinmtData[0].slotType == "App Video Consults"){
                    callType = "Video"
                }else {
                    callType = "Phone"
                }
                MemberIDs = self.scheduledAppoinmtData[0].memberID
                VideoRoomName = self.scheduledAppoinmtData[0].videoRoomName
                let date1 = Utils.getStringFromDate(date: Utils.getDateFromString(dateStr: self.scheduledAppoinmtData[0].selectedDate, format: "dd-MMM-yyyy"), format: "EEE, MMM dd, yyyy")
                self.message_Lbl.text = "Connect by \(callType)\n on \(date1) \n At \(String(describing: self.scheduledAppoinmtData[0].time!))"
                if (callType == "Video") {
                    self.timer = Timer.scheduledTimer(timeInterval: NumberFormatter().number(from: self.scheduledAppoinmtData[0].timerDuration) as! TimeInterval, target: self, selector: #selector(self.adjustmentBestSongBpmHeartRate), userInfo: nil, repeats: false)
                }else{
                    
                }
            }else{
                self.message_Lbl.text = "You do not have appointments scheduled yet."
            }
        }, failureCallback: {(error) in
            
        })
    }
    @objc func adjustmentBestSongBpmHeartRate() {
        self.joinVideoCallBtnOutlet.setTitle("Join Video Call", for: .normal)
    }
}
