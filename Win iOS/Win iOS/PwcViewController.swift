//
//  PwcViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 16/05/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit

var pwcvalidator = ""

class PwcViewController: UIViewController, customViewDelegate {

    @IBOutlet weak var welcomeTxt_Lbl: UILabel!
    @IBOutlet weak var toolbar: UITabBar!
    var customViews = CustomView()
    var customViewValidatorStr = ""
    @IBOutlet weak var familybuildingsupport_Lbl: UILabel!
    @IBOutlet weak var parantalSupport_Lbl: UILabel!
    @IBOutlet weak var childCaresupport_Lbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toolbar.selectedItem = toolbar.items?[0]
        welcomeTxt_Lbl.text = LoadLoginData.welcomeText
        self.customViews.customViewDelegates = self
        toolbar.delegate = self
        familybuildingsupport_Lbl.forHomeScreenMenuLabel()
        parantalSupport_Lbl.forHomeScreenMenuLabel()
        childCaresupport_Lbl.forHomeScreenMenuLabel()
        
       // print(LoadLoginData.contactUs)
        
    }
     override func viewWillAppear(_ animated: Bool) {
            presentIndex = "1"
            self.toolbar.selectedItem = toolbar.items?[0]
        
        
    //        if(LoadLoginData.dadiProgram == "Yes"){
    //               winForHimStackView.isHidden = true
    //               secondStackView.addArrangedSubview(understandBenefitsStackView)
    //               secondStackView.addArrangedSubview(fertilityTrackerStackView)
    //            secondStackView.spacing = 20
    //            firststackVIew.spacing = 20
    //        }
        }
    override func viewDidAppear(_ animated: Bool) {
        if(LoadLoginData.updateApp == "Yes"){
//                         if(updateAppLink){
//                             updateAppLink = false
//                             customViewValidatorStr = "Update App"
//                           //  DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [unowned self] in
//                                 print("time ended")
//                                 self.customViews.loadingData(titleLabl: "", subTitleLabel: "There is a latest version of the app available. Do you wish to update?", cancelBtnTitle: "Later", okayBtnTitle: "Update Now")
//                                 self.view.addSubview(self.customViews)
//                           //  }
//                         }
                }
        }
    func cancelBtnAction(sender: AnyObject) {
        self.customViews.removeFromSuperview()
    }
    
    func okayBtnAction(sender: AnyObject) {
        if(customViewValidatorStr == "Update App"){
            if let url = URL(string: "itms-apps://itunes.apple.com/app/id1286581528"),
                UIApplication.shared.canOpenURL(url){
                UIApplication.shared.openURL(url)
            }
        }else{
            self.customViews.removeFromSuperview()
        }
    }
    @IBAction func familybuildsupportBtnAction(_ sender: Any) {
        pwcvalidator = "familybuildsupport"
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func parentalsupportbtnAction(_ sender: Any) {
        pwcvalidator = "parantalsupport"
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChildCareSupportViewController") as? ChildCareSupportViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func childcareSupportBtnAction(_ sender: Any) {
        pwcvalidator = "childcaresupport"
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChildCareSupportViewController") as? ChildCareSupportViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if (item.tag == 1){
            if(presentIndex != "1"){
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PwcViewController") as? PwcViewController
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }else if (item.tag == 2){
            if(presentIndex != "2"){
                if (UserDefaults.standard.bool(forKey: UserDefaultsStored.UserLogedInOrNot)){
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FamilyBuildingViewController") as? FamilyBuildingViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                }else{
                    self.customViews.loadingData(titleLabl: "", subTitleLabel: AppConstants.AlertMessage.notRegistered.rawValue, cancelBtnTitle: "Cancel", okayBtnTitle: "Okay")
                    self.view.addSubview(self.customViews)
                }
            }
        }else if (item.tag == 3){
            if(presentIndex != "3"){
                pwcvalidator = "parantalsupport"
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChildCareSupportViewController") as? ChildCareSupportViewController
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }else if (item.tag == 4){
            if(presentIndex != "4"){
                if (UserDefaults.standard.bool(forKey: UserDefaultsStored.UserLogedInOrNot)){
                    pwcvalidator = "childcaresupport"
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChildCareSupportViewController") as? ChildCareSupportViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                }else{
                    self.customViews.loadingData(titleLabl: "", subTitleLabel: AppConstants.AlertMessage.notRegistered.rawValue, cancelBtnTitle: "Cancel", okayBtnTitle: "Okay")
                    self.view.addSubview(self.customViews)
                }
            }
        }else if (item.tag == 5){
            if(presentIndex != "5"){
                if (UserDefaults.standard.bool(forKey: UserDefaultsStored.UserLogedInOrNot)){
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NurseConnectViewController") as? NurseConnectViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                }else{
                    self.customViews.loadingData(titleLabl: "", subTitleLabel: AppConstants.AlertMessage.notRegistered.rawValue, cancelBtnTitle: "Cancel", okayBtnTitle: "Okay")
                    self.view.addSubview(self.customViews)
                }
            }
        }else if (item.tag == 6){
            if(presentIndex != "6"){
                if (UserDefaults.standard.bool(forKey: UserDefaultsStored.UserLogedInOrNot)){
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                }else{
                    self.customViews.loadingData(titleLabl: "", subTitleLabel: AppConstants.AlertMessage.notRegistered.rawValue, cancelBtnTitle: "Cancel", okayBtnTitle: "Okay")
                    self.view.addSubview(self.customViews)
                }
            }
        }
    }

}
