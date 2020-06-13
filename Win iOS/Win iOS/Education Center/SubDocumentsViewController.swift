//
//  SubDocumentsViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 30/01/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit

class SubDocumentsViewController: UIViewController {

    var strAuthNo = ""
    var strContract = ""
    var EmptyDoc = ""
    var arrSubLetter = [DocList]()
    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var subDocTableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subDocTableview.tableFooterView = UIView()
        getSubDocList()
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
    func getSubDocList() {
        var requestDict = [String: String]()
        requestDict["AuthNo"] = self.strAuthNo
        requestDict["Contract"] = self.strContract
        ApiCalls(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.loadLetter.Api, successCallback: {(result) in
            if (result.count > 0) {
                for i in 0...result.count - 1 {
                    let dataObject = DocList.init(json: result[i] as! Dictionary<String, AnyObject>)
                    self.arrSubLetter.append(dataObject)
                }
            }else {
                self.EmptyDoc = "No Documents Available."
            }
            self.subDocTableview.reloadData()
        }, failureCallback: {(error) in
            
        })
    }
}
extension SubDocumentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if(arrSubLetter.count > 0){
             self.subDocTableview.showEmptyListMessage("")
         }else{
             self.subDocTableview.showEmptyListMessage("\(String(describing: EmptyDoc))")
         }
        return arrSubLetter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SubLatterCell = tableView.dequeueReusableCell(withIdentifier: "LetterCell") as! SubLatterCell
        cell.title_Lbl.text = arrSubLetter[indexPath.row].docType
        cell.subTitle_Lbl.text = arrSubLetter[indexPath.row].date
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailDocViewController") as? DetailDocViewController
        vc!.strMemberID = arrSubLetter[indexPath.row].memberID
        vc!.strPDFDocument = arrSubLetter[indexPath.row].pDF_Document
         self.navigationController?.pushViewController(vc!, animated: true)
    }
}

class SubLatterCell: UITableViewCell {
    
    @IBOutlet weak var title_Lbl: UILabel!
    @IBOutlet weak var subTitle_Lbl: UILabel!
}
