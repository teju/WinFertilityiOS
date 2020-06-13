//
//  ViewController.swift
//  Win iOS
//
//  Created by BALARAM SOMINENI on 07/01/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

var eduLink = ""

import UIKit

class ViewController: UIViewController, customViewDelegate {
    func cancelBtnAction(sender: AnyObject) {
        self.customView.removeFromSuperview()
    }
    
    func okayBtnAction(sender: AnyObject) {
        print("Okay btn clicked")
    }
    
    var attrs = [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16.0),
            NSAttributedString.Key.foregroundColor : UIColor.fromHexaString(hex: "16284C"),
            NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
    var attributedString = NSMutableAttributedString(string:"")
    @IBOutlet weak var sampleLabel: UILabel!
    @IBOutlet weak var skipBtnOutlet: UIButton!
    @IBOutlet weak var createAccountBtnOutlet: UIButton!
    @IBOutlet weak var signinBtnOutlet: UIButton!
    var customView = CustomView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customView.customViewDelegates = self
        self.createAccountBtnOutlet.layer.cornerRadius = 20
        self.createAccountBtnOutlet.layer.borderWidth = 2
        self.createAccountBtnOutlet.layer.borderColor = UIColor.fromHexaString(hex: "318DDE").cgColor
        self.signinBtnOutlet.layer.cornerRadius = 20
        self.signinBtnOutlet.layer.borderWidth = 2
        self.signinBtnOutlet.layer.borderColor = UIColor.fromHexaString(hex: "318DDE").cgColor
        let buttonTitleStr = NSMutableAttributedString(string:"SKIP REGISTRATION", attributes:attrs)
        attributedString.append(buttonTitleStr)
        skipBtnOutlet.setAttributedTitle(attributedString, for: .normal)
        print("\(ApiMethodsName.loginApi.Api)")
        if (UserDefaults.standard.bool(forKey: UserDefaultsStored.UserLogedInOrNot)){
            self.skipBtnOutlet.isHidden = true
            self.createAccountBtnOutlet.isHidden = true
            self.signinBtnOutlet.isHidden = true
                self.loginApiCalls()
        }else{
            
        }
    }
    @IBAction func skipButtonClick(_ sender: Any) {
//        Createaccount/infocenter
        let requestDict = [String: String]()
        ApiCall(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.skipRegistration.Api, successCallback: { (results) in
            if(results != nil){
                eduLink = results!["Data"] as? String ?? ""
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                self.navigationController?.pushViewController(vc!, animated: true)
            }else{
                self.customView.loadingData(titleLabl: "", subTitleLabel: errorMessages, cancelBtnTitle: "Okay", okayBtnTitle: "")
                self.view.addSubview(self.customView)
            }
        }, failureCallback: {(errorMsg) in
            self.customView.loadingData(titleLabl: "", subTitleLabel: "Please check your internet connection and try again.", cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(self.customView)
        })
        
    }
    func loginApiCalls(){
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            var requestDict = [String: String]()
            if (UserDefaults.standard.bool(forKey: UserDefaultsStored.UserLogedInOrNot)){
                requestDict["EmailID"] = UserDefaults.standard.string(forKey: UserDefaultsStored.emailID)
                requestDict["Password"] = UserDefaults.standard.string(forKey: UserDefaultsStored.password)
            }else{
                
            }
            requestDict["FingerPrint"] = "Yes"
            requestDict["EncryptPassword"] = ""
            requestDict["DeviceType"]    = "iOS"
            requestDict["Version"] = appVersion
            
            ApiCall(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.loginApi.Api, successCallback: { (results) in
                let loginData = logindata(json: results!)
                print(loginData.result!)
                print(loginData.contactUs!)
                if(LoadLoginData.result! == 2){
                     if (UserDefaults.standard.bool(forKey: UserDefaultsStored.UserLogedInOrNot)){
                        self.requestAutToken()
                        
                     }else{
                        UserDefaults.standard.set(true, forKey: UserDefaultsStored.UserLogedInOrNot)
                            self.requestAutToken()
                    }
//                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
//                    self.navigationController?.pushViewController(vc!, animated: true)
                }else{
                    if(loginData.message == "Login Failed, Password does not match with the system"){
                         UserDefaults.standard.set(false, forKey: UserDefaultsStored.UserLogedInOrNot)
                        self.view.layoutIfNeeded()
                        self.skipBtnOutlet.isHidden = false
                        self.createAccountBtnOutlet.isHidden = false
                        self.signinBtnOutlet.isHidden = false
//                    self.customView.loadingData(titleLabl: "", subTitleLabel: "Login Failed, Password does not match with the system.", cancelBtnTitle: "Okay", okayBtnTitle: "")
//                   self.view.addSubview(self.customView)
                    }
                   
                }
            }, failureCallback:{(errorMsg) in
                 self.customView.loadingData(titleLabl: "", subTitleLabel: "Please check your internet connection and try again.", cancelBtnTitle: "Okay", okayBtnTitle: "")
                 self.view.addSubview(self.customView)
            })
        }
    func requestAutToken(){
    var requstDict = [String: String]()
    requstDict["UserName"] = UserDefaults.standard.string(forKey: UserDefaultsStored.emailID)
    requstDict["Password"] = UserDefaults.standard.string(forKey: UserDefaultsStored.password)
    AuthGetTokenApiCall(requestDict: requstDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.getTokenId.Api, successCallback: { (results) in
        let token = (results?["Token"] as! NSDictionary).value(forKey: "TokenId") as! String
        UserDefaults.standard.set(token, forKey: UserDefaultsStored.tokenID)
        if(LoadLoginData.contractIdentified == "PWC"){
                   let story = UIStoryboard(name: "Main", bundle:nil)
                   let vc = story.instantiateViewController(withIdentifier: "PwcViewController") as! PwcViewController
                   let navigationController = UINavigationController(rootViewController: vc)
                   navigationController.isNavigationBarHidden = true
                   UIApplication.shared.windows.first?.rootViewController = navigationController
                   UIApplication.shared.windows.first?.makeKeyAndVisible()
       }else{
        let story = UIStoryboard(name: "Main", bundle:nil)
                         let vc = story.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                         let navigationController = UINavigationController(rootViewController: vc)
                         navigationController.isNavigationBarHidden = true
                         UIApplication.shared.windows.first?.rootViewController = navigationController
                         UIApplication.shared.windows.first?.makeKeyAndVisible()
       }
    }, failureCallback: {(error) in
        self.customView.loadingData(titleLabl: "", subTitleLabel: "Please check your internet connection and try again.", cancelBtnTitle: "Okay", okayBtnTitle: "")
        self.view.addSubview(self.customView)
    })
}
}

