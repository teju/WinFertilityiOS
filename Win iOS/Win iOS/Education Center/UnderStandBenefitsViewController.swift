//
//  UnderStandBenefitsViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 28/01/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit

class UnderStandBenefitsViewController: UIViewController {

    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var myBenefitsBtnoutlet: UIButton!
    @IBOutlet weak var findaDoctorOutlet: UIButton!
    @IBOutlet weak var accumulatorBtnOutlet: UIButton!
    @IBOutlet weak var myDocumentsBtnOutlet: UIButton!
    @IBOutlet weak var patientIdentificationBtnOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        myBenefitsBtnoutlet.addBorder(side: .top, color: .lightGray, width: 1)
        myBenefitsBtnoutlet.addBorder(side: .bottom, color: .lightGray, width: 1)
        findaDoctorOutlet.addBorder(side: .bottom, color: .lightGray, width: 1)
        accumulatorBtnOutlet.addBorder(side: .bottom, color: .lightGray, width: 1)
        myDocumentsBtnOutlet.addBorder(side: .bottom, color: .lightGray, width: 1)
        patientIdentificationBtnOutlet.addBorder(side: .bottom, color: .lightGray, width: 1)
        accumulatorBtnOutlet.isHidden = true
        patientIdentificationBtnOutlet.isHidden = true
        myDocumentsBtnOutlet.isHidden = true
        findaDoctorOutlet.isHidden = true
         if(LoadLoginData.NSP == "Yes"){
            myBenefitsBtnoutlet.isHidden = false
         }else{
        if(LoadLoginData.appRegistered == "Yes"){
            myDocumentsBtnOutlet.isHidden = false
        }
        if(LoadLoginData.premiere == "Yes"){
            accumulatorBtnOutlet.isHidden = false
            patientIdentificationBtnOutlet.isHidden = false
        }
        if(LoadLoginData.networkProvider == "Yes"){
            findaDoctorOutlet.isHidden = false
        }
        }
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
        self.navigationController?.backToViewController(viewController: HomeViewController.self)
    }
    
}
