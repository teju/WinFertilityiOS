//
//  ParantalSupportViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 19/05/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit

class ParantalSupportViewController: UIViewController, customViewDelegate {
    func cancelBtnAction(sender: AnyObject) {
        self.customViews.removeFromSuperview()
    }
    
    func okayBtnAction(sender: AnyObject) {
        self.customViews.removeFromSuperview()
    }
    

    @IBOutlet weak var tabbar: UITabBar!
    var customViews = CustomView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabbar.selectedItem = tabbar.items?[2]
        self.customViews.customViewDelegates = self
        tabbar.delegate = self
        presentIndex = "3"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.backToViewController(viewController: PwcViewController.self)
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
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ParantalSupportViewController") as? ParantalSupportViewController
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }else if (item.tag == 4){
            if(presentIndex != "4"){
                if (UserDefaults.standard.bool(forKey: UserDefaultsStored.UserLogedInOrNot)){
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
