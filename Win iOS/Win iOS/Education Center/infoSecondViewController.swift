//
//  infoSecondViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 28/01/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit

class infoSecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, customViewDelegate {

    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var articalIndex_Lbl: UILabel!
    @IBOutlet weak var tableview: UITableView!
    var educationTableviewData = NSMutableArray()
    var url = String()
    var articledata = NSDictionary()
    var customViews = CustomView()
    override func viewDidLoad() {
        super.viewDidLoad()
        customViews.customViewDelegates = self
        tableview.delegate = self
        tableview.dataSource = self
        url = (articledata.value(forKey: "link") as? String)!
        print(articledata)
        articalIndex_Lbl.text = (articledata.value(forKey: "name") as? String)!.uppercased()
        gettingEduApiCall()
        tableview.rowHeight = UITableView.automaticDimension
        self.tableview.tableFooterView = UIView()
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
            presentIndex = "3"
            self.tabbar.selectedItem = tabbar.items?[2]
        }
    }
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func cancelBtnAction(sender: AnyObject) {
        self.tabbar.selectedItem = tabbar.items?[2]
        self.customViews.removeFromSuperview()
    }
    func okayBtnAction(sender: AnyObject) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return educationTableviewData.count
       }
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell:ArticleIndexTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Articlecell") as! ArticleIndexTableViewCell
           cell.title_Lbl.text = (educationTableviewData.value(forKey: "name") as! NSArray)[indexPath.row] as? String
       
           if ((educationTableviewData.value(forKey: "image") as! NSArray)[indexPath.row] as! String != "") {
               cell.img_Imageview.downloaded(from: (educationTableviewData.value(forKey: "image") as! NSArray)[indexPath.row] as! String)
           }else{
               cell.img_Imageview.image = UIImage(named: "placeholder")
           }
           cell.img_Imageview.layer.borderWidth = 2
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        cell.img_Imageview.layer.borderColor = UIColor.fromHexaString(hex: "318DDE").withAlphaComponent(0.7).cgColor
           return cell
       }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
        let articleData = educationTableviewData[indexPath.row] as! NSDictionary
        let benefitsOverviewVC = Utils.getViewController(storyboardName: "Main", storyboardId: "InfoDetailsViewController") as! InfoDetailsViewController
        benefitsOverviewVC.articledata = articleData
        self.navigationController?.pushViewController(benefitsOverviewVC, animated: true)
    }
    func gettingEduApiCall(){
        var requestDict = [String: String]()
        requestDict["URL"] = url
        ApiCall(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.getEducationDetails.Api, successCallback: {(result) in
            if let responseDict = result as NSDictionary? {
                let listdata = ((responseDict.value(forKey: "rss") as! NSDictionary).value(forKey: "channel") as! NSDictionary).value(forKey: "item") as! NSArray
                for i in 0...listdata.count - 1 {
                    self.educationTableviewData.add(listdata[i])
                }
                self.educationTableviewData.removeObject(at: 0)
                self.tableview.reloadData()
            }else{
                self.customViews.loadingData(titleLabl: "", subTitleLabel: errorMessages, cancelBtnTitle: "Okay", okayBtnTitle: "")
                self.view.addSubview(self.customViews)
            }
        }, failureCallback: {(error) in
            self.customViews.loadingData(titleLabl: "", subTitleLabel: errorMessages, cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(self.customViews)
        })
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
                        pwcvalidator = "childcaresupport"
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
class ArticleIndexTableViewCell: UITableViewCell {
    @IBOutlet weak var img_Imageview: UIImageView!
    @IBOutlet weak var title_Lbl: UILabel!
}
