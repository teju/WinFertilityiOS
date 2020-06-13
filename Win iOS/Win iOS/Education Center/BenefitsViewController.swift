//
//  BenefitsViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 28/01/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit
import WebKit

class BenefitsViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var tabbar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gettingEduApiCall()
//        if let url = URL(string: "http://managed.winfertility.com/jquerytest.html") {
//            let request = URLRequest(url: url)
//            webView.load(request)
//        }
        
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
        presentIndex = "4"
        self.tabbar.selectedItem = tabbar.items?[3]
        }
    }
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func pwcwebviewApiCall(){
        var requestDict = [String: String]()
               requestDict["URL"] = "http://managed.winfertility.com/pwc-test/feed/?accordion=4021"
               ApiCall(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.getEducationDetails.Api, successCallback: {(result) in
                   if let responseDict = result as NSDictionary? {
                       let listdata = (((responseDict.value(forKey: "rss") as! NSDictionary).value(forKey: "channel") as! NSDictionary).value(forKey: "htmlcontent") as! NSDictionary).value(forKey: "#cdata-section") as! String
                       self.webView.loadHTMLString(listdata, baseURL: nil)
                   }else{
                       
                   }
               }, failureCallback: {(error) in
                   
               })
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
        requestDict["URL"] = LoadLoginData.benefitsOverview
        ApiCall(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.getEducationDetails.Api, successCallback: {(result) in
            if let responseDict = result as NSDictionary? {
                if   let listdata = ((((responseDict.value(forKey: "rss") as! NSDictionary).value(forKey: "channel") as! NSDictionary).value(forKey: "item") as! NSDictionary).value(forKey: "htmlcontent") as! NSDictionary).value(forKey: "#cdata-section") as? String {
                    self.webView.loadHTMLString(listdata, baseURL: nil)
                }
            }else{
                
            }
        }, failureCallback: {(error) in
            
        })
    }

}
extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}
