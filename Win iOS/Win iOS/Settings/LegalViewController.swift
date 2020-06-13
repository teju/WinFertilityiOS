//
//  LegalViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 30/01/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit
import WebKit

class LegalViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var title_Lbl: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var tabbar: UITabBar!
    var url = ""
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
        self.tabbar.delegate = self
        self.tabbar.selectedItem = tabbar.items?[5]
        webView.navigationDelegate = self
        if legalAndPrivacyValidator {
            title_Lbl.text = "TERMS OF USE"
            url = "https://managed.winfertility.com/terms-of-use/feed"
        }else{
            title_Lbl.text = "PRIVACY POLICY"
            url = "https://managed.winfertility.com/privacy-policy/feed"
        }
        gettingEduApiCall()
    }
    override func viewWillAppear(_ animated: Bool) {
        presentIndex = "6"
        //self.tabbar.selectedItem = tabbar.items?[5]
    }
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("Start loading")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
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
                self.webView.loadHTMLString(listdata, baseURL: nil)
            }else{
                
            }
        }, failureCallback: {(error) in
            
        })
    }
}
