//
//  FeedBackViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 07/05/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit


class FeedBackViewController: UIViewController, customViewDelegate {
    func cancelBtnAction(sender: AnyObject) {
        self.customView.removeFromSuperview()
    }
    
    func okayBtnAction(sender: AnyObject) {
        
    }
    

   var customView = CustomView()
    @IBOutlet weak var nurseCare: FloatRatingView!
    @IBOutlet weak var videoquality: FloatRatingView!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customView.customViewDelegates = self
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
    }
    
    @IBAction func backBtnClick(_ sender: Any) {
        
    }
    @IBAction func sendBtnClick(_ sender: Any) {
        var requstDict = [String: String]()
        requstDict["EmailId"] = UserDefaults.standard.string(forKey: UserDefaultsStored.emailID)
        requstDict["Feedback"] = textView.text
        requstDict["NurseQuality"] = "\(nurseCare.rating)"
        requstDict["CallQuality"] = "\(videoquality.rating)"
        AuthGetTokenApiCall(requestDict: requstDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.saveFeedback.Api, successCallback: { (results) in
            print(results)
            let token = (results?["Token"] as! NSDictionary).value(forKey: "TokenId") as! String
            UserDefaults.standard.set(token, forKey: UserDefaultsStored.tokenID)
            let story = UIStoryboard(name: "Main", bundle:nil)
            let vc = story.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.isNavigationBarHidden = true
            UIApplication.shared.windows.first?.rootViewController = navigationController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }, failureCallback: {(error) in
            self.customView.loadingData(titleLabl: "", subTitleLabel: "Please check your internet connection and try again.", cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(self.customView)
        })
    }
    
   

}
