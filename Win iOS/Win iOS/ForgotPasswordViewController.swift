//
//  ForgotPasswordViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 23/01/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailID_Txt: UITextField!
    @IBOutlet weak var errMessage_Lbl: UILabel!
    @IBOutlet weak var loginButtonStackview: UIStackView!
    @IBOutlet weak var passwordStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButtonStackview.isHidden = true
        errMessage_Lbl.isHidden = true
        // Do any additional setup after loading the view.
    }
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func signInBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func createAccountBtnAction(_ sender: Any) {
        
    }
    @IBAction func recoverPasswordBtnAction(_ sender: Any) {
        let emailIDValidation = validateFields()
        if !(emailIDValidation.isValidated){
            errMessage_Lbl.isHidden = false
            errMessage_Lbl.text = emailIDValidation.validationMessage
        }else{
            var requestDict = [String: String]()
            requestDict["EmailID"] = emailID_Txt.text
            requestDict["FirstName"] = ""
            requestDict["LastName"] = ""
            ApiCall(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.forgotPassword.Api, successCallback: { (results) in
                let forgotPasswordDatas = forgotPasswordResult.init(json: results!)
                if(forgotPasswordDatas.result == 1){
                    self.passwordStackView.isHidden = true
                    self.loginButtonStackview.isHidden = false
                }else{
                    self.errMessage_Lbl.text = forgotPasswordDatas.message
                }
            }, failureCallback: {(errorMsg) in
                self.errMessage_Lbl.text = errorMessages
            })
        }
    }
    @IBAction func loginBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    private func validateFields() -> (isValidated:Bool, validationMessage:String) {
        
        var isValidated = true
        var validationMssg = ""
        
        guard emailID_Txt.text != "" else{
            isValidated = false
            validationMssg = errorMessage.loginEmptyEmailID_Msg.rawValue
            return (isValidated, validationMssg)
        }
        guard emailID_Txt.text!.isValidEmail() else {
            isValidated = false
            validationMssg = errorMessage.loginWorngEmailID_Msg.rawValue
            return (isValidated, validationMssg)
        }
        return (isValidated, validationMssg)
    }
    
}
