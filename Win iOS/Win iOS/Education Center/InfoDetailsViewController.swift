//
//  InfoDetailsViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 28/01/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit
import WebKit

class InfoDetailsViewController: UIViewController,UIWebViewDelegate, WKNavigationDelegate, customViewDelegate {
    
    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var title_Lbl: UILabel!
    @IBOutlet weak var webview: WKWebView!
    var articledata = NSDictionary()
    var url = String()
    var customViews = CustomView()
    override func viewDidLoad() {
        super.viewDidLoad()
        url = (articledata.value(forKey: "link") as? String)!
        gettingEduApiCall()
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
        func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
            guard let url = request.url, navigationType == .linkClicked else { return true }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return false
        }
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.navigationType == .linkActivated  {
                if let url = navigationAction.request.url,
                    let host = url.host, !host.hasPrefix("www.apple.com"),
                    UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                    print(url)
                    print("Redirected to browser. No need to open it locally")
                    decisionHandler(.cancel)
                } else {
                    print("Open it locally")
                    decisionHandler(.allow)
                }
            } else {
                print("not a user click")
                decisionHandler(.allow)
            }
        }
    func gettingEduApiCall(){
        
        var requestDict = [String: String]()
        requestDict["URL"] = url
        ApiCall(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.getEducationDetails.Api, successCallback: {(result) in
            if let responseDict = result as NSDictionary? {
                let listdata = (((responseDict.value(forKey: "rss") as! NSDictionary).value(forKey: "channel") as! NSDictionary).value(forKey: "htmlcontent") as! NSDictionary).value(forKey: "#cdata-section") as! String
                self.webview.loadHTMLString(listdata, baseURL: nil)
                let listdatas = (((responseDict.value(forKey: "rss") as! NSDictionary).value(forKey: "channel") as! NSDictionary).value(forKey: "title") as! NSDictionary).value(forKey: "#cdata-section") as! String
                self.title_Lbl.text = listdatas.uppercased()
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
                     let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FamilyBuildingViewController") as? FamilyBuildingViewController
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
