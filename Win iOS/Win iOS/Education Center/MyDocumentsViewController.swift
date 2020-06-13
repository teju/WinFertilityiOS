//
//  MyDocumentsViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 30/01/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit

class MyDocumentsViewController: UIViewController {
    
    @IBOutlet weak var documentsTableView: UITableView!
    @IBOutlet weak var tabbar: UITabBar!
    
    var letterArr = [DocList]()
    var EmptyDoc = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        documentsTableView.tableFooterView = UIView()
        loadDocuments()
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
    func loadDocuments(){
        var requestDict = [String:String]()
        requestDict = ["EmailID": LoadLoginData.emailID]
        ApiCalls(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.loadAuth.Api, successCallback: {(result) in
            if (result.count > 0) {
                for i in 0...result.count - 1 {
                    let dataObject = DocList.init(json: result[i] as! Dictionary<String, AnyObject>)
                    self.letterArr.append(dataObject)
                }
            }else {
                self.EmptyDoc = "No Documents Available."
            }
            self.documentsTableView.reloadData()
        }, failureCallback: {(error) in
            
        })
    }
    
}
extension MyDocumentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(letterArr.count > 0){
            self.documentsTableView.showEmptyListMessage("")
        }else{
            self.documentsTableView.showEmptyListMessage("\(String(describing: EmptyDoc))")
        }
        return letterArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LetterCell = tableView.dequeueReusableCell(withIdentifier: "DocCell") as! LetterCell
        cell.lblTitle.text = letterArr[indexPath.row].cPTDesc
        var str = (letterArr[indexPath.row].date).replacingOccurrences(of: "(", with: "", options: NSString.CompareOptions.literal, range: nil)
        str = str.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range: nil)
        cell.lblSubTitle.text = letterArr[indexPath.row].authNo + "\n" + str
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SubDocumentsViewController") as? SubDocumentsViewController
        vc!.strAuthNo = letterArr[indexPath.row].authNo
        vc!.strContract = letterArr[indexPath.row].contract
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
class LetterCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
}
