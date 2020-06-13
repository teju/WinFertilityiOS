//
//  SettingsViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 30/01/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

var legalAndPrivacyValidator = Bool()

import UIKit

class SettingsViewController: UIViewController, customViewDelegate {
   
    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var profileBtnOutlet: UIButton!
    @IBOutlet weak var myAppointmentsBtnOutlet: UIButton!
    @IBOutlet weak var manageAlertsAndNotificationsBtnAction: UIButton!
    @IBOutlet weak var termsOfUseBtnOutlet: UIButton!
    @IBOutlet weak var privacyPolicyBtnClick: UIButton!
    @IBOutlet weak var appTechSupportBtnClick: UIButton!
    @IBOutlet weak var logoutBtnClick: UIButton!
    @IBOutlet weak var contactUsBtnOutlet: UIButton!
    
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
        customViews.customViewDelegates = self
        profileBtnOutlet.addBorder(side: .top, color: .lightGray, width: 1)
        profileBtnOutlet.addBorder(side: .bottom, color: .lightGray, width: 1)
        myAppointmentsBtnOutlet.addBorder(side: .bottom, color: .lightGray, width: 1)
        manageAlertsAndNotificationsBtnAction.addBorder(side: .bottom, color: .lightGray, width: 1)
        termsOfUseBtnOutlet.addBorder(side: .bottom, color: .lightGray, width: 1)
        privacyPolicyBtnClick.addBorder(side: .bottom, color: .lightGray, width: 1)
        appTechSupportBtnClick.addBorder(side: .bottom, color: .lightGray, width: 1)
        contactUsBtnOutlet.addBorder(side: .bottom, color: .lightGray, width: 1)
        logoutBtnClick.addBorder(side: .bottom, color: .lightGray, width: 1)
        myAppointmentsBtnOutlet.isHidden = true
         if(LoadLoginData.NSP == "Yes"){
            myAppointmentsBtnOutlet.isHidden = false
         }else{
        if(LoadLoginData.appRegistered == "Yes"){
            myAppointmentsBtnOutlet.isHidden = false
        }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        presentIndex = "6"
        self.tabbar.selectedItem = tabbar.items?[5]
    }
    override func viewDidAppear(_ animated: Bool) {
        if (openedNotification) {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ManageAlertsViewController") as? ManageAlertsViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    @IBAction func termsOfUseBtnAction(_ sender: Any) {
        legalAndPrivacyValidator = true
    }
    @IBAction func privacyPolicyBtnAction(_ sender: Any) {
        legalAndPrivacyValidator = false
    }
    @IBAction func backBtnClick(_ sender: Any) {
        if(LoadLoginData.contractIdentified == "PWC"){
        self.navigationController?.backToViewController(viewController: PwcViewController.self)
         }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func contactUsBtnClick(_ sender: Any) {
        pwcvalidator = "cantactUs"
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChildCareSupportViewController") as? ChildCareSupportViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func logoutBtnAction(_ sender: Any) {
        customViews.loadingData(titleLabl: "", subTitleLabel: "Are you sure you want to logout?", cancelBtnTitle: "Cancel", okayBtnTitle: "Yes")
        self.view.addSubview(customViews)
    }
    func cancelBtnAction(sender: AnyObject) {
        self.customViews.removeFromSuperview()
       }
   func okayBtnAction(sender: AnyObject) {
       let domain = Bundle.main.bundleIdentifier!
       UserDefaults.standard.removePersistentDomain(forName: domain)
       let story = UIStoryboard(name: "Main", bundle:nil)
       let vc = story.instantiateViewController(withIdentifier: "ViewController") as! ViewController
       let navigationController = UINavigationController(rootViewController: vc)
       navigationController.isNavigationBarHidden = true
       UIApplication.shared.windows.first?.rootViewController = navigationController
       UIApplication.shared.windows.first?.makeKeyAndVisible()
   }
}
