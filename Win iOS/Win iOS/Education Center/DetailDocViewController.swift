//
//  DetailDocViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 07/02/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit
import PDFKit

class DetailDocViewController: UIViewController {

    var strPDFDocument = "", strMemberID = ""
    var pdfURL: URL!
    
    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var pdfView: PDFView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pdfView.autoScales = true
        loadDetailLetter()
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
    func loadDetailLetter() {
        var requestDict = [String: String]()
       requestDict["PDF_Document"] = self.strPDFDocument
       requestDict["MemberID"] = self.strMemberID
        ApiCall(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.loadandConvertDocument.Api, successCallback: {(result) in
            if result != nil {
            self.showPDF(result!["Data"] as! String)
            }
        }, failureCallback: {(error) in
            
        })
    }
    func showPDF(_ url: String) {
        
        guard let checkURL =  URL(string: url) else {
            return
        }
        let pdfDocument = PDFDocument(url: checkURL)
        pdfView.document = pdfDocument
    }
}
