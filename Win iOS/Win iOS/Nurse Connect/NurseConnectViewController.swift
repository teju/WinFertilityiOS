//
//  NurseConnectViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 23/01/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

var callType = ""
var isSubmitAquasation = false

import UIKit

class NurseConnectViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, ToolbarPickerViewDelegate, customViewDelegate {
    
    
    var ListOfOptions =  ["Select","Call Now", "Schedule Phone Appointment", "Schedule Video Appointment", "Submit A Question"]
    @IBOutlet weak var appointmentType_Txt: ZWTextField!
    @IBOutlet weak var viewCorrentAppointmentStackView: UIStackView!
    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var nextBtnOutlet: UIButton!
    @IBOutlet weak var viewCurrentAppointmentBtnOutlet: UIButton!
    @IBOutlet weak var viewCurrentAppointment_Lbl: UILabel!
    
    var timer:Timer?
    var durations = [String]()
    var validationListResult = [validationList]()
    var customViews = CustomView()
    var pickerView = ToolbarPickerView()
    var joinVideoCall = Bool()
    var isFromFamily = false
    override func viewDidLoad() {
        super.viewDidLoad()
        joinVideoCall = false
        nextBtnOutlet.isHidden = true
        customViews.customViewDelegates = self
        viewCorrentAppointmentStackView.isHidden = true
        viewCurrentAppointmentBtnOutlet.isHidden = true
        appointmentType_Txt.inputView = pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
        appointmentType_Txt.inputAccessoryView = self.pickerView.toolbar
        self.pickerView.toolbarDelegate = self
        if(LoadLoginData.NSP == "Yes"){
            durations =  ["Select", "Schedule Phone Appointment", "Schedule Video Appointment"]
        }else{
        if(LoadLoginData.appRegistered == "Yes"){
            if(LoadLoginData.videoConsults == "Yes"){
                durations = ["Select","Call Now", "Schedule Phone Appointment", "Schedule Video Appointment", "Submit A Question"]
            }else {
                durations = ["Select","Call Now", "Schedule Phone Appointment", "Submit A Question"]
            }
        }else{
          durations =  ["Select","Call Now", "Submit A Question"]
        }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        timer?.invalidate()
        if(LoadLoginData.contractIdentified == "PWC"){
            presentIndex = "5"
            self.tabbar.selectedItem = tabbar.items?[4]
                self.tabbar.items![1].image = UIImage(named: "icon-toolbar-family-building")
                self.tabbar.items![1].selectedImage = UIImage(named: "icon-toolbar-family-building-active")
                self.tabbar.items![2].image = UIImage(named: "icon-toolbar-parental")
                self.tabbar.items![2].selectedImage = UIImage(named: "icon-toolbar-parental-active")
                self.tabbar.items![3].image = UIImage(named: "icon-toolbar-benefits-childcare")
                self.tabbar.items![3].selectedImage = UIImage(named: "icon-toolbar-benefits-childcare-active")
                self.tabbar.items![4].image = UIImage(named: "icon-connect")
                self.tabbar.items![4].selectedImage = UIImage(named: "icon-connect-active")
        }else{
            presentIndex = "2"
            self.tabbar.selectedItem = tabbar.items?[1]
        }
        viewCurrentAppointmentBtnOutlet.setTitle(" View", for: .normal)
        viewCurrentAppointmentBtnOutlet.isHidden = true
        self.validationListResult.removeAll()
        self.viewCorrentAppointmentStackView.isHidden = false
        self.viewCurrentAppointment_Lbl.text = ""
        callType = ""
        isSubmitAquasation = false
        
        gettingCurrentAppointmentDetails()
    }
    func cancelBtnAction(sender: AnyObject) {
           self.customViews.removeFromSuperview()
       }
       
   func okayBtnAction(sender: AnyObject) {
       self.navigationController?.popToRootViewController(animated: true)
   }
    @IBAction func backBtnClick(_ sender: Any) {
         if(LoadLoginData.contractIdentified == "PWC" && isFromFamily){
        self.navigationController?.backToViewController(viewController: PwcViewController.self)
         }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func nextBtnClick(_ sender: Any) {
        if(appointmentType_Txt.text == "Call Now") {
            callingApi(str: "Connect with a WIN nurse-call-\(String(describing: LoadLoginData.mobileNumber))")
            guard let number = URL(string: "tel://" + LoadLoginData.mobileNumber) else { return }
            UIApplication.shared.open(number)
        }else if(appointmentType_Txt.text == "Schedule Phone Appointment"){
            callType = "App Phone Consults"
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ScheduleAppointmentViewController") as? ScheduleAppointmentViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }else if(appointmentType_Txt.text == "Schedule Video Appointment"){
            callType = "App Video Consults"
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ScheduleAppointmentViewController") as? ScheduleAppointmentViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }else if(appointmentType_Txt.text == "Submit A Question"){
            isSubmitAquasation = true
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AppTechSupportViewController") as? AppTechSupportViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            
        }
    }
    @IBAction func viewCurrentAppointmentBtnClick(_ sender: Any) {
        callType = validationListResult[0].slotType
        if(joinVideoCall){
           GetTwilioToken()
        }else{
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ScheduleAppointmentViewController") as? ScheduleAppointmentViewController
        self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerView.backgroundColor = UIColor.fromHexaString(hex: "0A182B")
        return durations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return durations[row]
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        pickerView.subviews[1].backgroundColor = UIColor.lightGray
        pickerView.subviews[2].backgroundColor = UIColor.lightGray
        let pickerLabel = UILabel()
        pickerLabel.textColor = (row == pickerView.selectedRow(inComponent: component)) ? UIColor.white : UIColor.gray
        pickerLabel.font = UIFont(name: "Graphie-Regular", size: 22)
        pickerLabel.text = durations[row]
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.selectRow(row, inComponent: component, animated: true)
        pickerView.reloadComponent(component)
        appointmentType_Txt.text = durations[row]
        nextBtnOutlet.isHidden = false
        if(appointmentType_Txt.text == "Call Now") {
            nextBtnOutlet.setTitle("Dial Contact Number", for: .normal)
        }else if(appointmentType_Txt.text == "Schedule Phone Appointment"){
            nextBtnOutlet.setTitle("Next", for: .normal)
        }else if(appointmentType_Txt.text == "Schedule Video Appointment"){
            nextBtnOutlet.setTitle("Next", for: .normal)
        }else if(appointmentType_Txt.text == "Submit A Question"){
            nextBtnOutlet.setTitle("Next", for: .normal)
        }else{
            nextBtnOutlet.isHidden = true
        }
    }
    func didTapDone() {
        self.view.endEditing(true)
    }
    
    func didTapCancel() {
        self.view.endEditing(true)
    }
}

extension NurseConnectViewController {
    func GetTwilioToken(){
       var responceDict = [String: String]()
        responceDict["Room"] = validationListResult[0].videoRoomName
        responceDict["Name"] = validationListResult[0].memberID
        ApiCall(requestDict: responceDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.getTwilioToken.Api, successCallback: {(result) in
            print(result)
            if result != nil {
                twilioTokenId = result!["Data"] as! String
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VideoChatViewController") as? VideoChatViewController
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }, failureCallback: {(error) in
            self.customViews.loadingData(titleLabl: "", subTitleLabel: errorMessages, cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(self.customViews)
        })
    }
    func gettingCurrentAppointmentDetails(){
        MemberIDs = ""
        VideoRoomName = ""
        var requestDict = [String:String]()
        requestDict["Email"] = LoadLoginData.emailID
        ApiCalls(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.validationList.Api, successCallback: {(result)  in
            if result.count > 0 {
                for i in 0...result.count - 1 {
                    let dataObject = validationList.init(json: result[i] as! Dictionary<String, AnyObject>)
                    self.validationListResult.append(dataObject)
                }
                if(self.validationListResult[0].slotType! == "App Phone Consults"){
                    self.viewCorrentAppointmentStackView.isHidden = false
                    self.viewCurrentAppointmentBtnOutlet.isHidden = false
                    callType = "App Phone Consults"
                    self.viewCurrentAppointment_Lbl.text = "You have a Phone Appointment Scheduled."
                }else if(self.validationListResult[0].slotType == "App Video Consults"){
                    self.timer = Timer.scheduledTimer(timeInterval: NumberFormatter().number(from: self.validationListResult[0].timerDuration) as! TimeInterval, target: self, selector: #selector(self.adjustmentBestSongBpmHeartRate), userInfo: nil, repeats: false)
                    self.viewCorrentAppointmentStackView.isHidden = false
                    self.viewCurrentAppointmentBtnOutlet.isHidden = false
                    callType = "App Video Consults"
                    self.viewCurrentAppointment_Lbl.text = "You have a Video Appointment Scheduled."
                }else{
                    
                }
                MemberIDs = self.validationListResult[0].memberID
                VideoRoomName = self.validationListResult[0].videoRoomName
               
                print("Validations List having some data")
            }else{
                self.viewCorrentAppointmentStackView.isHidden = true
                print("Validations List is Empty")
            }
        }, failureCallback: {(errorMsg) in
            self.customViews.loadingData(titleLabl: "", subTitleLabel: errorMessages, cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(self.customViews)
        })
    }
    @objc func adjustmentBestSongBpmHeartRate() {
        joinVideoCall = true
        self.viewCurrentAppointmentBtnOutlet.setTitle("Join Video Call", for: .normal)
    }
}

