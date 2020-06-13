//
//  ChildCareSupportViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 19/05/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit
import WebKit

class ChildCareSupportViewController: UIViewController, customViewDelegate, WKNavigationDelegate {
    func cancelBtnAction(sender: AnyObject) {
        self.customViews.removeFromSuperview()
    }
    
    func okayBtnAction(sender: AnyObject) {
        self.customViews.removeFromSuperview()
    }
    

    @IBOutlet weak var title_Lbl: UILabel!
    @IBOutlet weak var webViewOutlet: WKWebView!
    @IBOutlet weak var tabbar: UITabBar!
    var customViews = CustomView()
    var url = ""
    override func viewDidLoad() {
        super.viewDidLoad()
            self.customViews.customViewDelegates = self
        
        tabbar.delegate = self
        
         //url = "http://managed.winfertility.com/pwc-test.html"
//        let request = URLRequest(url: "http://managed.winfertility.com/pwc-test.html")
//        let url = NSURL(string: request)
//        let request1 = NSURLRequest(URL: url!)
    webViewOutlet.navigationDelegate = self
        var myBlog = ""
        if(pwcvalidator == "familybuildsupport"){
            presentIndex = "2"
            self.tabbar.selectedItem = tabbar.items?[1]
            title_Lbl.text = "FAMILY-BUILDING SUPPORT"
           myBlog  = "http://managed.winfertility.com/pwc-test/feed/?accordion=4021"
        }else if(pwcvalidator == "cantactUs"){
            title_Lbl.text = "CONTACTS"
            presentIndex = "6"
            self.tabbar.selectedItem = tabbar.items?[5]
            myBlog  = LoadLoginData.contactUs
    }else if(pwcvalidator == "parantalsupport"){
            title_Lbl.text = "PARENTAL SUPPORT"
            presentIndex = "3"
            self.tabbar.selectedItem = tabbar.items?[2]
            myBlog  = "http://managed.winfertility.com/pwc-test/feed/?accordion=4141"
        }else{
            title_Lbl.text = "CHILDCARE SUPPORT"
            presentIndex = "4"
            self.tabbar.selectedItem = tabbar.items?[3]
            myBlog  = "http://managed.winfertility.com/pwc-test/feed/?accordion=4156"
        }
        //let myBlog = "http://managed.winfertility.com/pwc-test.html"
        let url = NSURL(string: myBlog)
        let request = NSURLRequest(url: url! as URL)
        webViewOutlet.load(request as URLRequest)
        //gettingEduApiCall()
    }
    
    @IBAction func backBtnClick(_ sender: Any) {
        print("pwcvalidator \(pwcvalidator)")
        if(pwcvalidator == "familybuildsupport"){
            self.navigationController?.popViewController(animated: true)
        }else if(pwcvalidator == "cantactUs"){
            self.navigationController?.popViewController(animated: true)
        } else{
        self.navigationController?.backToViewController(viewController: PwcViewController.self)
        }
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        showGlobalProgressHUDWithTitle(title: "")
        print("Start loading")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        dismissGlobalHUD()
        print("End loading")
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
                self.webViewOutlet.loadHTMLString(listdata, baseURL: nil)
            }else{
                
            }
        }, failureCallback: {(error) in
            
        })
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
