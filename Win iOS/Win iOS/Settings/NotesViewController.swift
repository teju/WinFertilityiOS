//
//  NotesViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 12/02/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//



import UIKit

class NotesViewController: UIViewController, customViewDelegate {
    func cancelBtnAction(sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func okayBtnAction(sender: AnyObject) {
        print("Okay btn pressed")
    }
    
    
    @IBOutlet weak var title_Lbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabbar: UITabBar!
    var lastContentOffset: CGFloat = 0
    
    let kHeaderSectionTag: Int = 6900
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    var sectionItems: Array<Any> = []
    var sectionNames: Array<Any> = []
    var sectionSubNames = NSMutableArray()
    var sectionSelection: Array<NSMutableArray> = []
    
    var textviewtag = Int()
    var indextag = Int()
    
    var customViews = CustomView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            self.tabbar.delegate = self
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
            presentIndex = "5"
            self.tabbar.selectedItem = tabbar.items?[4]
        }
        customViews.customViewDelegates = self
        if let selDate = selectedDateNotes {
            let date1 = Utils.getStringFromDate(date: selDate, format: "EEEE, MMM dd, yyyy")
            title_Lbl.text = date1
        }
        sectionNames = ["NOTES","PERIOD","SEX DRIVE","PERSONAL SYMPTOMS","INTERCOURSE","MOOD","OVULATION TESTS","MEDICATIONS","PREGNANCY TESTS",]
        sectionSubNames = ["","","","","","","","","",]
        sectionItems = [
            ["Notes"],
            ["None", "Spotty", "Light", "Medium", "Heavy", "1st Day"],
            ["Need some alone time", "Lead the way", "I'm ready"],
            ["Ah Ok", "Cramps", "Tender Breasts", "Headache","Multiple Symptoms"],
            ["No","Protected","Unprotected"],
            ["Happy", "Emotional", "Stressed", "Tired", "Moody"],
            ["Please Enter Brand and Result"],
            ["Medication Taken"],
            ["Prenancy Taken"],
        ]
        sectionSelection = [
            [false],
            [false, false, false, false, false, false],
            [false, false, false],
            [false, false, false, false, false],
            [false,false,false],
            [false, false, false, false, false],
            [false],
            [false],
            [false],
        ]
        //self.tableView.prefetchDataSource = self
        if notesData.value(forKey: "EventDate") as! String != "" {
        if let notes = notesData.value(forKey: "Notes") as? String{
            sectionSubNames[0] = notes
            let senctiondatass = sectionSelection[0]
            senctiondatass[0] = true
        }
        if let notes = notesData.value(forKey: "Period") as? String{
            sectionSubNames[1] = notes
            let indexvalue = (sectionItems[1] as! NSArray).index(of: notes)
            let senctiondatass = sectionSelection[1]
            senctiondatass[indexvalue] = true
        }
        if let notes = notesData.value(forKey: "SexDrive") as? String{
            sectionSubNames[2] = notes
            let indexvalue = (sectionItems[2] as! NSArray).index(of: notes)
            let senctiondatass = sectionSelection[2]
            senctiondatass[indexvalue] = true
        }
        if let notes = notesData.value(forKey: "PersonalSymptoms") as? String{
            sectionSubNames[3] = notes
            let indexvalue = (sectionItems[3] as! NSArray).index(of: notes)
            let senctiondatass = sectionSelection[3]
            senctiondatass[indexvalue] = true
        }
        if let notes = notesData.value(forKey: "SexualActivity") as? String{
            sectionSubNames[4] = notes
            let indexvalue = (sectionItems[4] as! NSArray).index(of: notes)
            let senctiondatass = sectionSelection[4]
            senctiondatass[indexvalue] = true
        }
        if let notes = notesData.value(forKey: "Mood") as? String{
            sectionSubNames[5] = notes
            let indexvalue = (sectionItems[5] as! NSArray).index(of: notes)
            let senctiondatass = sectionSelection[5]
            senctiondatass[indexvalue] = true
        }
        if let notes = notesData.value(forKey: "OvulationTests") as? String{
            sectionSubNames[6] = notes
            // let indexvalue = (sectionItems[6] as! NSArray).index(of: notes)
            let senctiondatass = sectionSelection[6]
            senctiondatass[0] = true
        }
        if let notes = notesData.value(forKey: "Medications") as? String{
            sectionSubNames[7] = notes
            //let indexvalue = (sectionItems[7] as! NSArray).index(of: notes)
            let senctiondatass = sectionSelection[7]
            senctiondatass[0] = true
        }
        if let notes = notesData.value(forKey: "PregnancyTests") as? String{
            sectionSubNames[8] = notes
            //let indexvalue = (sectionItems[8] as! NSArray).index(of: notes)
            let senctiondatass = sectionSelection[8]
            senctiondatass[0] = true
        }
        }
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension;
        self.tableView.estimatedSectionHeaderHeight = 25;
        self.tableView!.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        
    }
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func saveBtnClick(_ sender: Any) {
        gettingDataFromserver()
    }
    func gettingDataFromserver(){
        var requestDict = [String: String]()
        requestDict["EmailID"] = LoadLoginData.emailID
        if let selDate = selectedDateNotes {
            requestDict["EventDate"] = Utils.getStringFromDate(date: selDate, format: "MM/dd/yyyy")
            requestDict["EventID"] = notesData.value(forKey: "EventID") as? String
        }else{
            requestDict["EventID"] = ""
        }
        requestDict["Notes"] = self.sectionSubNames[0] as? String
        requestDict["Period"] = self.sectionSubNames[1] as? String
        requestDict["SexDrive"] = self.sectionSubNames[2] as? String
        requestDict["PersonalSymptoms"] = self.sectionSubNames[3] as? String
        requestDict["SexualActivity"] = self.sectionSubNames[4] as? String
        requestDict["Mood"] = self.sectionSubNames[5] as? String
        requestDict["OvulationTests"] = self.sectionSubNames[6] as? String
        requestDict["Medications"] = self.sectionSubNames[7] as? String
        requestDict["PregnancyTests"] = self.sectionSubNames[8] as? String
        print(requestDict)
        ApiCall(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.saveEvents.Api, successCallback: {(result) in
            print(result)
            self.customViews.loadingData(titleLabl: "", subTitleLabel: "Successfully Saved", cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(self.customViews)
        }, failureCallback: {(error) in
            self.customViews.loadingData(titleLabl: "", subTitleLabel: "\(AppConstants.AlertMessage.genericError)", cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(self.customViews)
        })
    }
}


extension NotesViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print("prefetchdRowsAtIndexpath \(indexPaths)")
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("cancelPrefetchingForRowsAtIndexpath \(indexPaths)")
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.lastContentOffset < scrollView.contentOffset.y {
             
        } else if self.lastContentOffset > scrollView.contentOffset.y {
             
        } else {
            // print("didn't move")// didn't move
        }
    }
    func tableViewScrollToBottom(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if sectionNames.count > 0 {
            //tableView.backgroundView = nil
            return sectionNames.count
        } else {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
            messageLabel.text = "Retrieving data.\nPlease wait."
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)!
            messageLabel.sizeToFit()
            self.tableView.backgroundView = messageLabel;
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        let separatorView = UIView(frame: CGRect(x: tableView.separatorInset.left, y: footerView.frame.height, width: tableView.frame.width - tableView.separatorInset.right - tableView.separatorInset.left, height: 1))
        if #available(iOS 13.0, *) {
            separatorView.backgroundColor = UIColor.separator
        } else {
            // Fallback on earlier versions
        }
        footerView.addSubview(separatorView)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.expandedSectionHeaderNumber == section) {
            let arrayOfItems = self.sectionItems[section] as! NSArray
            return arrayOfItems.count;
        } else {
            return 0;
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0;
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: UITableViewHeaderFooterView  = NotesView() as UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.white
        header.textLabel?.textColor = UIColor.fromHexaString(hex: "16284C")
        header.textLabel?.text = sectionNames[section] as? String
        if let viewWithTag = self.view.viewWithTag(kHeaderSectionTag + section) {
            print(viewWithTag)
            viewWithTag.removeFromSuperview()
        }
        if let viewWithTag = self.view.viewWithTag(500 + section) {
            print(viewWithTag)
            viewWithTag.removeFromSuperview()
        }

        let headerFrame = self.view.frame.size
        let theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 50, y: 10, width: 40, height: 40));
        theImageView.image = UIImage(named: "Plus")
        theImageView.tag = kHeaderSectionTag + section
        theImageView.isUserInteractionEnabled = true
        header.addSubview(theImageView)
        print(500 + section)
            if let viewWithTag = self.view.viewWithTag(500 + section) as? UILabel {
                print(viewWithTag)
                viewWithTag.removeFromSuperview()
            }//else{
        let thelabel = UILabel(frame: CGRect(x: 20, y: 40, width: (headerFrame.width - 60), height: 18));
        thelabel.tag = 500 + section
        thelabel.font = thelabel.font.withSize(13)
        thelabel.text = ""
        thelabel.text = sectionSubNames[section] as? String
        thelabel.numberOfLines = 0

        //print("the label add\(500 + section)")
        //thelabel.removeFromSuperview()
        header.addSubview(thelabel)
        // }
        header.tag = section
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(NotesViewController.sectionHeaderWasTouched(_:)))
        header.addGestureRecognizer(headerTapGesture)
        return header
    }
    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//
//
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var cell = UITableViewCell()
        let section = self.sectionItems[indexPath.section] as! NSArray
        let sectioncell = self.sectionSelection[indexPath.section] as NSArray
        if(section[indexPath.row] as? String == "Notes"){
            let  cell: NotesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath) as! NotesTableViewCell
            cell.notes.tag = 1050
            textviewtag = 1050
            indextag = 0
            if(sectionSubNames[0] as? String != ""){
                cell.notes.text = sectionSubNames[0] as? String
            }else{
                cell.notes.text = "Notes"
                cell.notes.textColor = UIColor.lightGray
            }
            cell.notes.delegate = self
            return cell
        }else if(section[indexPath.row] as? String == "Please Enter Brand and Result"){
            let cell: NotesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath) as! NotesTableViewCell
            cell.notes.tag = 1051
            textviewtag = 1051
            indextag = 6
            if(sectionSubNames[6] as? String != ""){
                cell.notes.text = sectionSubNames[6] as? String
            }else{
                cell.notes.text = "Please Enter Brand and Result"
                cell.notes.textColor = UIColor.lightGray
            }
            cell.notes.delegate = self
            return cell
        }else if(section[indexPath.row] as? String == "Medication Taken"){
            let cell: NotesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath) as! NotesTableViewCell
            cell.notes.tag = 1052
            textviewtag = 1052
            indextag = 7
            if(sectionSubNames[7] as? String != ""){
                cell.notes.text = sectionSubNames[7] as? String
            }else{
                cell.notes.text = "Medication Taken"
                cell.notes.textColor = UIColor.lightGray
            }
            cell.notes.delegate = self
            return cell
        }else if(section[indexPath.row] as? String == "Prenancy Taken"){
            let cell: NotesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath) as! NotesTableViewCell
            cell.notes.tag = 1053
            textviewtag = 1053
            indextag = 8
            if(sectionSubNames[8] as? String != ""){
                cell.notes.text = sectionSubNames[8] as? String
            }else{
                cell.notes.text = "Please Enter Brand and Result"
                cell.notes.textColor = UIColor.lightGray
            }
            cell.notes.delegate = self
            return cell
        }else{
            
            let  cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as UITableViewCell
            
            cell.textLabel?.textColor = UIColor.black
            cell.textLabel?.text = section[indexPath.row] as? String
            if(sectioncell[indexPath.row] as! Bool == true){
                cell.backgroundColor = UIColor.fromHexaString(hex: "E084BC")
            }else{
                cell.backgroundColor = UIColor.lightText
            }
            return cell
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = self.sectionItems[indexPath.section] as! NSArray
        let sectioncell = self.sectionSelection[indexPath.section]
        //let section = self.sectionItems[indexPath.section] as! NSArray
        for i in 0...sectioncell.count {
            sectioncell[i] = false
        }
        
        sectionSubNames[indexPath.section] = section[indexPath.row] as! String
        sectioncell[indexPath.row] = true
//        for i in 500...508 {
//        let thelabel = self.view.viewWithTag(i) as! UILabel
//        thelabel.text = section[indexPath.row] as? String
//        }
        print(sectionSubNames)
        let cImageView = self.view.viewWithTag(kHeaderSectionTag + self.expandedSectionHeaderNumber) as? UIImageView
        let sectionHeaderView = tableView.headerView(forSection: indexPath.section)!
        sectionHeaderView.contentView.backgroundColor = UIColor.white
        tableViewCollapeSection(self.expandedSectionHeaderNumber, imageView: cImageView!, view: sectionHeaderView)
        tableView.reloadData()
       
    }
    // MARK: - Expand / Collapse Methods
    private func tableView(tableView: UITableView, animationForRowAtIndexPaths indexPaths: [NSIndexPath]) -> UITableView.RowAnimation {
        return .none
    }
    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section    = headerView.tag
        let eImageView = headerView.viewWithTag(kHeaderSectionTag + section) as? UIImageView
        
        if (self.expandedSectionHeaderNumber == -1) {
            self.expandedSectionHeaderNumber = section
            headerView.contentView.backgroundColor = UIColor.fromHexaString(hex: "16284C")
            headerView.textLabel?.textColor = UIColor.white
            tableViewExpandSection(section, imageView: eImageView!, view: headerView)
            
        } else {
            if (self.expandedSectionHeaderNumber == section) {
                headerView.contentView.backgroundColor = UIColor.white
                headerView.textLabel?.textColor = UIColor.fromHexaString(hex: "16284C")
                tableViewCollapeSection(section, imageView: eImageView!, view: headerView)
            } else {
                let sectionHeaderView = tableView.headerView(forSection: self.expandedSectionHeaderNumber)!
                sectionHeaderView.contentView.backgroundColor = UIColor.white
                headerView.contentView.backgroundColor = UIColor.fromHexaString(hex: "16284C")
                headerView.textLabel?.textColor = UIColor.white
                let cImageView = self.view.viewWithTag(kHeaderSectionTag + self.expandedSectionHeaderNumber) as? UIImageView
                tableViewCollapeSection(self.expandedSectionHeaderNumber, imageView: cImageView!, view: sectionHeaderView)
                tableViewExpandSection(section, imageView: eImageView!, view: headerView)
            }
        }
    }
    
    func tableViewCollapeSection(_ section: Int, imageView: UIImageView, view: UITableViewHeaderFooterView) {
        let sectionData = self.sectionItems[section] as! NSArray
        print(kHeaderSectionTag)
        print(self.expandedSectionHeaderNumber)
        view.contentView.backgroundColor = UIColor.white
        view.textLabel?.textColor = UIColor.fromHexaString(hex: "16284C")
        self.expandedSectionHeaderNumber = -1;
        if (sectionData.count == 0) {
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                //imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
                imageView.image = UIImage(named: "Plus")
            })
            let thelabel = self.view.viewWithTag(500 + section) as! UILabel
            thelabel.textColor = UIColor.fromHexaString(hex: "16284C")
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.tableView!.beginUpdates()
            self.tableView!.deleteRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.tableView!.endUpdates()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableViewExpandSection(_ section: Int, imageView: UIImageView, view: UITableViewHeaderFooterView) {
        let sectionData = self.sectionItems[section] as! NSArray
        view.contentView.backgroundColor = UIColor.fromHexaString(hex: "16284C")
        view.textLabel?.textColor = UIColor.white
        if (sectionData.count == 0) {
            self.expandedSectionHeaderNumber = -1;
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                //imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
                imageView.image = UIImage(named: "Minus")
            })
            let thelabel = self.view.viewWithTag(500 + section) as! UILabel
            thelabel.textColor = .white
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.expandedSectionHeaderNumber = section
            self.tableView!.beginUpdates()
            self.tableView!.insertRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.tableView!.endUpdates()
        }
    }
}

extension NotesViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == self.view.viewWithTag(textviewtag) as! UITextView {
            sectionSubNames[indextag] = textView.text!
            print(textviewtag - 550)
            if textView.text.isEmpty {
                if (textviewtag == 1050){
                    textView.text = "Notes"
                    textView.textColor = UIColor.lightGray
                }
                if (textviewtag == 1051){
                    textView.text = "Please Enter Brand and Result"
                    textView.textColor = UIColor.lightGray
                }
                if (textviewtag == 1052){
                    textView.text = "Medication Taken"
                    textView.textColor = UIColor.lightGray
                }
                if (textviewtag == 1053){
                    textView.text = "Please Enter Brand and Result"
                    textView.textColor = UIColor.lightGray
                }
            }
//            let thelabel = self.view.viewWithTag(textviewtag - 550) as! UILabel
//            thelabel.text = textView.text!
            let indexvalue = sectionSelection[indextag]
            indexvalue[0] = true
        }else{
            
        }
        //        let pointsFromTop = CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude)
        //        tableView.setContentOffset(pointsFromTop, animated: true)
        expandedSectionHeaderNumber = -1
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
class CustomTableCell: UITableViewCell {
    
}
class NotesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var notes: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        notes.layer.cornerRadius = 6
        notes.layer.borderColor = UIColor.lightGray.cgColor
        notes.layer.borderWidth = 2
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}



