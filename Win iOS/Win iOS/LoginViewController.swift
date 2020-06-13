//
//  LoginViewController.swift
//  Win iOS
//
//  Created by BALARAM SOMINENI on 08/01/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailID_Txt: ZWTextField!
    @IBOutlet weak var password_Txt: ZWTextField!
    @IBOutlet weak var errorMessage_Lbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(LoadLoginData.appRegistered)
        // Do any additional setup after loading the view.
//        if (UserDefaults.standard.bool(forKey: UserDefaultsStored.UserLogedInOrNot)){
//            DispatchQueue.main.async {
//                self.loginApiCall()
//            }
//        }
    }
    //MARK: - Login Button Action
    @IBAction func loginBtnAction(_ sender: Any) {
        self.errorMessage_Lbl.text = ""
        let validationResult = loginBtnActionValidation()
        if(validationResult.1){
            loginApiCall()
        }else{
            self.errorMessage_Lbl.text = validationResult.0
        }
    }
    
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MA
    func loginBtnActionValidation() -> (String, Bool){
        var validationString = ""
        var validOrNot = true
        guard !emailID_Txt.text!.isEmpty else {
            validationString = errorMessage.loginEmptyEmailID_Msg.rawValue
            validOrNot = false
            return (validationString, validOrNot)
        }
        guard !password_Txt.text!.isEmpty else {
            validationString = errorMessage.loginEmptyPassword_Msg.rawValue
            validOrNot = false
            return (validationString, validOrNot)
        }
        guard emailID_Txt.text!.isValidEmail() else {
            validationString = errorMessage.loginWorngEmailID_Msg.rawValue
            validOrNot = false
            return (validationString, validOrNot)
        }
        
        return (validationString, validOrNot)
    }
    func loginApiCall(){
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        var requestDict = [String: String]()
        if (UserDefaults.standard.bool(forKey: UserDefaultsStored.UserLogedInOrNot)){
            requestDict["EmailID"] = UserDefaults.standard.string(forKey: UserDefaultsStored.emailID)
            requestDict["Password"] = UserDefaults.standard.string(forKey: UserDefaultsStored.password)
        }else{
            requestDict["EmailID"] = self.emailID_Txt.text!
            requestDict["Password"] = self.password_Txt.text!
        }
        requestDict["FingerPrint"] = "Yes"
        requestDict["EncryptPassword"] = ""
        requestDict["DeviceType"]    = "iOS"
        requestDict["Version"] = appVersion
        
        ApiCall(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.loginApi.Api, successCallback: { (results) in
            let loginData = logindata(json: results!)
            print(loginData.result!)
            if(LoadLoginData.result! == 2){
                 if (UserDefaults.standard.bool(forKey: UserDefaultsStored.UserLogedInOrNot)){
                    requestAutToken()
                    
                 }else{
                    UserDefaults.standard.set(true, forKey: UserDefaultsStored.UserLogedInOrNot)
                    UserDefaults.standard.set(self.emailID_Txt.text!, forKey: UserDefaultsStored.emailID)
                    UserDefaults.standard.set(self.password_Txt.text!, forKey: UserDefaultsStored.password)
                    requestAutToken()
                }
                if(LoadLoginData.contractIdentified == "PWC"){
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PwcViewController") as? PwcViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                }else{
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                self.navigationController?.pushViewController(vc!, animated: true)
                }
            }else{
                if (UserDefaults.standard.bool(forKey: UserDefaultsStored.UserLogedInOrNot)){
                    
                }else{
                self.errorMessage_Lbl.text = LoadLoginData.message!
                }
            }
        }, failureCallback:{(errorMsg) in
             if (UserDefaults.standard.bool(forKey: UserDefaultsStored.UserLogedInOrNot)){
//                let alert = UIAlertController(title: "", message:"Please check internet connection.", preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
             }else{
                self.errorMessage_Lbl.text = errorMessages
            }
        })
    }
}


func requestAutToken(){
    var requstDict = [String: String]()
    requstDict["UserName"] = UserDefaults.standard.string(forKey: UserDefaultsStored.emailID)
    requstDict["Password"] = UserDefaults.standard.string(forKey: UserDefaultsStored.password)
    AuthGetTokenApiCall(requestDict: requstDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.getTokenId.Api, successCallback: { (results) in
        let token = (results?["Token"] as! NSDictionary).value(forKey: "TokenId") as! String
        UserDefaults.standard.set(token, forKey: UserDefaultsStored.tokenID)
//        let story = UIStoryboard(name: "Main", bundle:nil)
//        let vc = story.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//        let navigationController = UINavigationController(rootViewController: vc)
//        navigationController.isNavigationBarHidden = true
//        UIApplication.shared.windows.first?.rootViewController = navigationController
//        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }, failureCallback: {(error) in
        
    })
}
