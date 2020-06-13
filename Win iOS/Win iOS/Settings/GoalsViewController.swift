//
//  GoalsViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 10/02/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit

class GoalsViewController: UIViewController {

    @IBOutlet weak var first_switch: UISwitch!
    @IBOutlet weak var second_Switch: UISwitch!
    @IBOutlet weak var third_Switch: UISwitch!
    @IBOutlet weak var fourth_Switch: UISwitch!
    @IBOutlet weak var fivth_Switch: UISwitch!
    @IBOutlet weak var sixth_Switch: UISwitch!
    
    var goalsData = ["","","","","",""]
    var fristGoal = "I want to track my cycle"
    var secondGoal = "I want to freeze my eggs/sperm"
    var thirdGoal = "I want to get pregnant"
    var fourthGoal = "I am considering/undergoing fertility treatment"
    var fivthGoal = "My partner is considering/undergoing fertility treatment"
    var sixthGoal = "I am interested in surrogacy or adoption"
    
    
    @IBOutlet weak var tabbar: UITabBar!
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
        self.tabbar.selectedItem = tabbar.items?[5]
        
        let goalTextss = ((goalTexts.removingCharacters(from: .newlines)).replacingOccurrences(of: "  ", with: " ")).replacingOccurrences(of: "/ ", with: "/")
        let goalStr = goalTextss.split{$0 == ","}.map(String.init)
        print(goalStr)
        if(goalStr.contains("I want to track my cycle")){
            first_switch.isOn = true
            goalsData[0].append(contentsOf: "I want to track my cycle")
        }
        if(goalStr.contains("I want to freeze my eggs/sperm")){
            second_Switch.isOn = true
            goalsData[1].append(contentsOf: "I want to freeze my eggs/sperm")
        }
        if(goalStr.contains("I want to get pregnant")){
            third_Switch.isOn = true
            goalsData[2].append(contentsOf: "I want to get pregnant")
        }
        if(goalStr.contains("I am considering/undergoing fertility treatment")){
            fourth_Switch.isOn = true
            goalsData[3].append(contentsOf: "I am considering/undergoing fertility treatment")
        }
        if(goalStr.contains("My partner is considering/undergoing fertility treatment")){
            fivth_Switch.isOn = true
            goalsData[4].append(contentsOf: "My partner is considering/undergoing fertility treatment")
        }
        if(goalStr.contains("I am interested in surrogacy or adoption")){
            sixth_Switch.isOn = true
            goalsData[5].append(contentsOf: "I am interested in surrogacy or adoption")
        }
    }
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func firstswitch(_ sender: Any) {
        if (first_switch.isOn){
            goalsData[0] = "I want to track my cycle"
        }else{
            goalsData[0] = ""
        }
    }
    @IBAction func secondSwitch(_ sender: Any) {
        if(second_Switch.isOn){
            goalsData[1] = "I want to freeze my eggs/sperm"
        }else{
            goalsData[1] = ""
        }
    }
    @IBAction func thirdSwitch(_ sender: Any) {
        if(third_Switch.isOn){
            goalsData[2] = "I want to get pregnant"
        }else{
            goalsData[2] = ""
        }
    }
    @IBAction func fourthSwitch(_ sender: Any) {
        if(fourth_Switch.isOn){
            goalsData[3] = "I am considering/undergoing fertility treatment"
        }else{
            goalsData[3] = ""
        }
    }
    @IBAction func fivthSwitch(_ sender: Any) {
        if(fivth_Switch.isOn){
                   goalsData[4] = "My partner is considering/undergoing treatment"
               }else{
                   goalsData[4] = ""
               }
    }
    @IBAction func sixthSwitch(_ sender: Any) {
        if(sixth_Switch.isOn){
            goalsData[5] = "I am interested in surrogacy or adoption"
        }else{
            goalsData[5] = ""
        }
    }
    
    @IBAction func nextBtnClick(_ sender: Any) {
        let strings = goalsData.filter{$0 != ""}
         let str = strings.joined(separator: ",")
        goalTexts = str
        self.navigationController?.popViewController(animated: true)
    }
    

}
