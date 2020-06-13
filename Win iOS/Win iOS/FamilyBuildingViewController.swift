//
//  HomeViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 23/01/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit

class FamilyBuildingViewController: UIViewController, customViewDelegate {
    
    
    @IBOutlet weak var pwc_stack_view: UIStackView!
    @IBOutlet weak var title_Lbl: UILabel!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var connectWithANurse_Lbl: UILabel!
    @IBOutlet weak var InfoCenter_Lbl: UILabel!
    @IBOutlet weak var fertilityTracker_Lbl: UILabel!
    @IBOutlet weak var benefits_Lbl: UILabel!
    @IBOutlet weak var maleFactor_Lbl: UILabel!
    
    @IBOutlet weak var winForHimStackView: UIStackView!
    @IBOutlet weak var understandBenefitsStackView: UIStackView!
    @IBOutlet weak var secondStackView: UIStackView!
    @IBOutlet weak var fertilityTrackerStackView: UIStackView!
    @IBOutlet weak var firststackVIew: UIStackView!
    @IBOutlet weak var informationCenterStackView: UIStackView!
    @IBOutlet weak var connectWithNurseStackView: UIStackView!
    
    @IBOutlet weak var familyTitle_Lbl: UILabel!
    @IBOutlet weak var backBtnOutlet: UIButton!
    @IBOutlet weak var winLogo: UIImageView!
    @IBOutlet weak var fullStackView: UIStackView!
    @IBOutlet weak var pwcstackView: UIStackView!
    
    @IBOutlet weak var pwcstackview1: UIStackView!
    @IBOutlet weak var pwcstackview2: UIStackView!
    var customViews = CustomView()
    var customViewValidatorStr = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title_Lbl.forHomeScreenLabel()
        self.connectWithANurse_Lbl.forHomeScreenMenuLabel()
        self.InfoCenter_Lbl.forHomeScreenMenuLabel()
        self.fertilityTracker_Lbl.forHomeScreenMenuLabel()
        self.benefits_Lbl.forHomeScreenMenuLabel()
        self.maleFactor_Lbl.forHomeScreenMenuLabel()
        customViews.customViewDelegates = self
        tabBar.selectedItem = tabBar.items?.first
        tabBar.delegate = self
        
//        pwcstackview1.spacing = 10
//        pwcstackview2.spacing = 20
        pwcstackView.isHidden = true
        if(LoadLoginData.contractIdentified == "PWC"){
            fullStackView.isHidden = true
            pwcstackView.isHidden = false
//            winForHimStackView.isHidden = true
//            firststackVIew.addArrangedSubview(self.understandBenefitsStackView)
//            firststackVIew.addArrangedSubview(self.connectWithNurseStackView)
//            secondStackView.addArrangedSubview(self.fertilityTrackerStackView)
//            secondStackView.addArrangedSubview(self.informationCenterStackView)
//            firststackVIew.spacing = 20
//            secondStackView.spacing = 20
//            fullStackView.spacing = 20
        }
       
    }
    override func viewWillAppear(_ animated: Bool) {
        if(LoadLoginData.contractIdentified == "PWC"){
                   familyTitle_Lbl.isHidden = false
                   backBtnOutlet.isHidden = false
                   winLogo.isHidden = true
                   presentIndex = "2"
                   self.tabBar.selectedItem = tabBar.items?[1]
                       self.tabBar.items![1].image = UIImage(named: "icon-toolbar-family-building")
                       self.tabBar.items![1].selectedImage = UIImage(named: "icon-toolbar-family-building-active")
                       self.tabBar.items![2].image = UIImage(named: "icon-toolbar-parental")
                       self.tabBar.items![2].selectedImage = UIImage(named: "icon-toolbar-parental-active")
                       self.tabBar.items![3].image = UIImage(named: "icon-toolbar-benefits-childcare")
                       self.tabBar.items![3].selectedImage = UIImage(named: "icon-toolbar-benefits-childcare-active")
                       self.tabBar.items![4].image = UIImage(named: "icon-connect")
                       self.tabBar.items![4].selectedImage = UIImage(named: "icon-connect-active")
               }else{
                   presentIndex = "1"
                   self.tabBar.selectedItem = tabBar.items?[0]
               }
        
//        if(LoadLoginData.dadiProgram == "Yes"){
//               winForHimStackView.isHidden = true
//               secondStackView.addArrangedSubview(understandBenefitsStackView)
//               secondStackView.addArrangedSubview(fertilityTrackerStackView)
//            secondStackView.spacing = 20
//            firststackVIew.spacing = 20
//        }
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.backToViewController(viewController: PwcViewController.self)
    }
    override func viewDidAppear(_ animated: Bool) {
       if(openedNotification){
                         let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController
                         self.navigationController?.pushViewController(vc!, animated: true)
                     }else{
                     if(LoadLoginData.updateApp == "Yes"){
                        if(LoadLoginData.contractIdentified == "PWC"){
                        }else{
                         if(updateAppLink){
                             updateAppLink = false
                             customViewValidatorStr = "Update App"
                           //  DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [unowned self] in
                                 print("time ended")
                                 self.customViews.loadingData(titleLabl: "", subTitleLabel: "There is a latest version of the app available. Do you wish to update?", cancelBtnTitle: "Later", okayBtnTitle: "Update Now")
                                 self.view.addSubview(self.customViews)
                           //  }
                         }
                     }
        }
                     }
    }
    @IBAction func connectWithAWinNurseBtnClick(_ sender: Any) {
        if (UserDefaults.standard.bool(forKey: UserDefaultsStored.UserLogedInOrNot)){
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NurseConnectViewController") as? NurseConnectViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            showPopUp()
        }
    }
    @IBAction func informationCenterBtnClick(_ sender: Any) {
    }
    @IBAction func understandingyourBenefitsBtnClick(_ sender: Any) {
        if(LoadLoginData.contractIdentified == "PWC"){
            pwcvalidator = "familybuildsupport"
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChildCareSupportViewController") as? ChildCareSupportViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
        if (UserDefaults.standard.bool(forKey: UserDefaultsStored.UserLogedInOrNot)){
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UnderStandBenefitsViewController") as? UnderStandBenefitsViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            showPopUp()
        }
        }
    }
    @IBAction func fertilityTrackerBtnClick(_ sender: Any) {
        if (UserDefaults.standard.bool(forKey: UserDefaultsStored.UserLogedInOrNot)){
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FertilityTrackerViewController") as? FertilityTrackerViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            showPopUp()
        }
    }
    @IBAction func malefactorBtnClick(_ sender: Any) {
        if (UserDefaults.standard.bool(forKey: UserDefaultsStored.UserLogedInOrNot)){
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "WinForHimViewController") as? WinForHimViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            showPopUp()
        }
    }
    public func showPopUp(){
        self.customViews.loadingData(titleLabl: "", subTitleLabel: "You must create an account or sign in to access this feature. Click Yes to proceed.", cancelBtnTitle: "Cancel", okayBtnTitle: "Ok")
        self.view.addSubview(customViews)
    }
    func cancelBtnAction(sender: AnyObject) {
        self.tabBar.selectedItem = tabBar.items?[0]
        self.customViews.removeFromSuperview()
    }
    
    func okayBtnAction(sender: AnyObject) {
        if(customViewValidatorStr == "Update App"){
            if let url = URL(string: "itms-apps://itunes.apple.com/app/id1286581528"),
                UIApplication.shared.canOpenURL(url){
                UIApplication.shared.openURL(url)
            }
        }else{
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if (item.tag == 1){
            if(presentIndex != "1"){
                if(LoadLoginData.contractIdentified == "PWC"){
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PwcViewController") as? PwcViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                }else{
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                self.navigationController?.pushViewController(vc!, animated: true)
                }
            }
        }else if (item.tag == 2){
            if(presentIndex != "2"){
                if (UserDefaults.standard.bool(forKey: UserDefaultsStored.UserLogedInOrNot)){
                     if(LoadLoginData.contractIdentified == "PWC"){
                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                        self.navigationController?.pushViewController(vc!, animated: true)
                     }else{
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NurseConnectViewController") as? NurseConnectViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                        }
                }else{
                    self.customViews.loadingData(titleLabl: "", subTitleLabel: AppConstants.AlertMessage.notRegistered.rawValue, cancelBtnTitle: "Cancel", okayBtnTitle: "Okay")
                    self.view.addSubview(self.customViews)
                }
            }
        }else if (item.tag == 3){
            if(presentIndex != "3"){
                if(LoadLoginData.contractIdentified == "PWC"){
                    pwcvalidator = "parantalsupport"
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChildCareSupportViewController") as? ChildCareSupportViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                }else{
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "INformationCenterViewController") as? INformationCenterViewController
                self.navigationController?.pushViewController(vc!, animated: true)
                }
            }
        }else if (item.tag == 4){
            if(presentIndex != "4"){
               
                if (UserDefaults.standard.bool(forKey: UserDefaultsStored.UserLogedInOrNot)){
                    if(LoadLoginData.contractIdentified == "PWC"){
                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChildCareSupportViewController") as? ChildCareSupportViewController
                        self.navigationController?.pushViewController(vc!, animated: true)
                        }else{
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UnderStandBenefitsViewController") as? UnderStandBenefitsViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                    }
                }else{
                    self.customViews.loadingData(titleLabl: "", subTitleLabel: AppConstants.AlertMessage.notRegistered.rawValue, cancelBtnTitle: "Cancel", okayBtnTitle: "Okay")
                    self.view.addSubview(self.customViews)
                }
            }
        }else if (item.tag == 5){
            if(presentIndex != "5"){
                if (UserDefaults.standard.bool(forKey: UserDefaultsStored.UserLogedInOrNot)){
                    if(LoadLoginData.contractIdentified == "PWC"){
                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NurseConnectViewController") as? NurseConnectViewController
                        self.navigationController?.pushViewController(vc!, animated: true)
                    }else{
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FertilityTrackerViewController") as? FertilityTrackerViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                    }
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
