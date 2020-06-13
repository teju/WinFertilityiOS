//
//  PatientIdentificationViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 29/01/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit

class PatientIdentificationViewController: UIViewController {

    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var name_Lbl: UILabel!
    @IBOutlet weak var employeeCode_Lbl: UILabel!
    @IBOutlet weak var companyName_Txt: UILabel!
    @IBOutlet weak var MembersPhoneNumber_Lbl: UILabel!
    @IBOutlet weak var providesPhoneNumber_Lbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name_Lbl.text = "\(String(describing: LoadLoginData.firstName!)) \(String(describing: LoadLoginData.lastName!))"
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
        MembersPhoneNumber_Lbl.isUserInteractionEnabled = true
        MembersPhoneNumber_Lbl.addGestureRecognizer(tap)
        let taps = UITapGestureRecognizer(target: self, action: #selector(self.tapFunctions))
        providesPhoneNumber_Lbl.isUserInteractionEnabled = true
        providesPhoneNumber_Lbl.addGestureRecognizer(taps)
        employeeCode_Lbl.text = LoadLoginData.employerCode ?? "----"
        companyName_Txt.text = LoadLoginData.employer ?? "----"
        MembersPhoneNumber_Lbl.text = LoadLoginData.phoneNumber
        providesPhoneNumber_Lbl.text = LoadLoginData.phoneNumber
        callingApi(str: "View Patient Identification")
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
    @objc func tapFunction(sender:UITapGestureRecognizer) {
       let str = (MembersPhoneNumber_Lbl.text)!.replacingOccurrences(of: "-", with: "")
        callingApi(str: "View Patient Identification \(str)")
             guard let number = URL(string: "tel://" + str) else { return }
              UIApplication.shared.open(number)
         }
    @objc func tapFunctions(sender:UITapGestureRecognizer) {
    let str = (MembersPhoneNumber_Lbl.text)!.replacingOccurrences(of: "-", with: "")
        callingApi(str: "View Patient Identification \(str)")
          guard let number = URL(string: "tel://" + str) else { return }
           UIApplication.shared.open(number)
      }
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
