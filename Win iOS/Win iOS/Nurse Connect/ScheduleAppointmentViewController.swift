//
//  ScheduleAppointmentViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 24/01/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

var typeOfCall = ""
//var submitQuestion = false


import UIKit
import JTAppleCalendar

class ScheduleAppointmentViewController: UIViewController, ToolbarPickerViewDelegate, customViewDelegate {
    
    func didTapDone() {
        view.endEditing(true)
    }
    
    func didTapCancel() {
        view.endEditing(true)
    }
    
    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var appointmentType_Lbl: UILabel!
    @IBOutlet weak var monthTitle_Lbl: UILabel!
    @IBOutlet weak var monthCollectionView: JTACMonthView!
    @IBOutlet weak var slotTime_Txt: ZWTextField!
    @IBOutlet weak var confirmBtnOutlet: UIButton!
    @IBOutlet weak var available_Lbl: UILabel!
    
    var customViews = CustomView()
    private let reuseIdentifier = "AppointmentTimeCellIdentifier"
    var selectedCalenderDate = Date()
    var testCalendar = Calendar.current
    var currentScrollModeIndex = 0
    var prePostVisibility: ((CellState, CellView?)->())?
    var dateArr = [String]()
    let formatter = DateFormatter()
    var dateObjects = [Date]()
    var numberOfRows = 6
    var generateInDates: InDateCellGeneration = .forAllMonths
    var generateOutDates: OutDateCellGeneration = .tillEndOfGrid
    var hasStrictBoundaries = true
    var appointmentDate = ""
    var arrAppointment = [Appointment]()
    var selectedTempDate = ""
    var confirmBtnValidator = false
    var monthSize: MonthSize? = nil
    var tempData = [String]()
    var bookDate = Date()
    var tempDate = Date()
    var selectMonth = Bool()
    var alreadyHavingAppointment = Bool()
    var timer:Timer?
    var selectedDate = ""
    var validationListResult = [validationList]()
    var pickerView: ToolbarPickerView!
    let allScrollModes: [ScrollingMode] = [
        .none,
        .nonStopTo(customInterval: 374, withResistance: 0.5),
        .nonStopToCell(withResistance: 0.5),
        .nonStopToSection(withResistance: 0.5),
        .stopAtEach(customInterval: 374),
        .stopAtEachCalendarFrame,
        .stopAtEachSection
    ]
    var popUpValidationString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.available_Lbl.layer.borderWidth = 1
        self.available_Lbl.layer.borderColor = UIColor.lightGray.cgColor
        customViews.customViewDelegates = self
        alreadyHavingAppointment = false
        confirmBtnOutlet.isHidden = true
        selectMonth = false
        if(callType == "App Phone Consults"){
            appointmentType_Lbl.text = "SCHEDULE PHONE APPOINTMENT"
        }else{
            
        }
        pickerView = ToolbarPickerView()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.slotTime_Txt.inputView = pickerView
        self.slotTime_Txt.inputAccessoryView = pickerView.toolbar
        pickerView.backgroundColor = UIColor.fromHexaString(hex: "0A182B")
        monthCollectionView.register(UINib(nibName: "PinkSectionHeaderView", bundle: Bundle.main),
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: "PinkSectionHeaderView")
        self.monthCollectionView.register(UINib(nibName: "PinkSectionHeaderView", bundle: Bundle.main),
                                          forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                          withReuseIdentifier: "PinkSectionHeaderView")
        self.monthCollectionView.scrollToDate(Date())
        self.monthCollectionView.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
        setupScrollMode()
        self.monthCollectionView.scrollToDate(Date())
    }
    override func viewWillAppear(_ animated: Bool) {
        if(LoadLoginData.contractIdentified == "PWC"){
            presentIndex = "5"
                self.tabbar.items![1].image = UIImage(named: "icon-toolbar-family-building")
                self.tabbar.items![1].selectedImage = UIImage(named: "icon-toolbar-family-building-active")
                self.tabbar.items![2].image = UIImage(named: "icon-toolbar-parental")
                self.tabbar.items![2].selectedImage = UIImage(named: "icon-toolbar-parental-active")
                self.tabbar.items![3].image = UIImage(named: "icon-toolbar-benefits-childcare")
                self.tabbar.items![3].selectedImage = UIImage(named: "icon-toolbar-benefits-childcare-active")
                self.tabbar.items![4].image = UIImage(named: "icon-connect")
                self.tabbar.items![4].selectedImage = UIImage(named: "icon-connect-active")
        }else{
            presentIndex = "2"
        }
        timer?.invalidate()
        selectMonth = false
        self.tabbar.selectedItem = tabbar.items?[1]
        self.pickerView.toolbarDelegate = self
        monthCollectionView.minimumLineSpacing = 1
        monthCollectionView.minimumInteritemSpacing = 1
        self.monthCollectionView.scrollToDate(Date())
        self.monthCollectionView.reloadData()
        
        gettingCurrentAppointmentDetails()
        selectMonth(Date())
        
    }
    func setupScrollMode() {
        currentScrollModeIndex = 6
        monthCollectionView.scrollingMode = allScrollModes[currentScrollModeIndex]
    }
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first?.date else {
            return
        }
        let month = testCalendar.dateComponents([.month], from: startDate).month!
        let monthName = DateFormatter().monthSymbols[(month-1) % 12]
        let year = testCalendar.component(.year, from: startDate)
        
        monthTitle_Lbl.text = monthName + " " + String(year)
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "dd-MMM-YYYY"
//                let dateFormatters = DateFormatter()
//                dateFormatters.dateFormat = "dd/MM/YYYY"
//                let date1 = dateFormatters.date(from: "01/\(month)/\(year)")!
        slotTime_Txt.text = "Select Time"
        confirmBtnOutlet.isHidden = true
        if !(validationListResult.isEmpty){
            let appointmentDate = Utils.getStringFromDate(date: Utils.getDateFromString(dateStr: validationListResult[0].selectedDate, format: "dd-MMM-yyyy"), format: "MMMM yyyy")
            if(monthTitle_Lbl.text == appointmentDate){
                if(self.validationListResult[0].slotType == "App Phone Consults"){
                    if(callType == "App Phone Consults"){
                        self.slotTime_Txt.text = self.validationListResult[0].time
                        self.confirmBtnOutlet.isHidden = false
                    }else{
                        self.confirmBtnOutlet.isHidden = true
                        self.slotTime_Txt.text = "Select Time"
                    }
                    
                    //                           self.viewCurrentAppointment_Lbl.text = "You have a Phone Appointment Scheduled."
                }else if(self.validationListResult[0].slotType == "App Video Consults"){
                    if(callType == "App Video Consults"){
                        self.slotTime_Txt.text = self.validationListResult[0].time
                        self.confirmBtnOutlet.isHidden = false
                    }else{
                        self.confirmBtnOutlet.isHidden = true
                        self.slotTime_Txt.text = "Select Time"
                    }
                }
            }else{
                slotTime_Txt.text = "Select Time"
                confirmBtnOutlet.isHidden = true
            }
        }else{
            print("Validation list not loaded")
        }
        if(selectMonth){
            selectMonth(Calendar.current.date(byAdding: .day, value: 0, to: startDate)!)
        }
    }
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func previousMonthBtnClick(_ sender: Any) {
        self.monthCollectionView.scrollToSegment(.previous)
        selectMonth = true
        //self.loadCalendarData()
    }
    @IBAction func nextMonthbtnClick(_ sender: Any) {
        self.monthCollectionView.scrollToSegment(.next)
        selectMonth = true
        //self.loadCalendarData()
    }
    @IBAction func confirmBtnAction(_ sender: Any) {
        if(confirmBtnOutlet.titleLabel?.text == "Join Video Call"){
            GetTwilioToken()
        }else {
            if(confirmBtnOutlet.titleLabel?.text == "Cancel Appointment"){
                self.popUpValidationString = "CancelAppointmentsClear"
            self.customViews.loadingData(titleLabl: "", subTitleLabel: "Are you want to cancel your appointment?", cancelBtnTitle: "No", okayBtnTitle: "Okay")
            self.view.addSubview(self.customViews)
            }else{
                scheduleAppointment()
            }
        }
    }
    func handleCellConfiguration(cell: JTACDayCell?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
        prePostVisibility?(cellState, cell as? CellView)
    }
    func handleCellTextColor(view: JTACDayCell?, cellState: CellState) {
        guard let myCustomCell = view as? CellView  else {
            return
        }
        if cellState.isSelected {
            //myCustomCell.dayLabel.textColor = .white
            myCustomCell.backgroundColor = UIColor.fromHexaString(hex: "16284C")
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                myCustomCell.dayLabel.textColor = .black
                myCustomCell.backgroundColor = UIColor.lightGray
                // myCustomCell.isUserInteractionEnabled = false
            } else {
                // myCustomCell.isUserInteractionEnabled = false
                myCustomCell.dayLabel.textColor = .lightGray
                myCustomCell.backgroundColor = UIColor.fromHexaString(hex: "C6C6C8")
            }
            if dateArr.contains( formatter.string(from: cellState.date)){
                myCustomCell.backgroundColor = .orange
            }
        }
        if (selectedCalenderDate == cellState.date){
            myCustomCell.backgroundColor = UIColor.blue//fromHexaString(hex: "94D60A")
        }
        if cellState.isSelected {
            //myCustomCell.dayLabel.textColor = .white
            myCustomCell.backgroundColor = UIColor.blue//UIColor.fromHexaString(hex: "16284C")
        }
        print("handleCellConfiguration")
    }
    func handleCellSelection(view: JTACDayCell?, cellState: CellState) {
        guard let myCustomCell = view as? CellView else {return }
        if (dateArr.contains( formatter.string(from: cellState.date))){
            myCustomCell.isUserInteractionEnabled = true
        }else{
            myCustomCell.isUserInteractionEnabled = false
        }
        // myCustomCell.isUserInteractionEnabled = false
        if cellState.dateBelongsTo == .thisMonth {
            if cellState.date < Date() {
                myCustomCell.backgroundColor = UIColor.fromHexaString(hex: "DEDEDE")
                myCustomCell.dayLabel.textColor = UIColor.gray
            }else{
                if (dateArr.contains( formatter.string(from: cellState.date))){
                    myCustomCell.backgroundColor = UIColor.white
                    myCustomCell.dayLabel.textColor = UIColor.darkGray
                }else{
                    myCustomCell.backgroundColor = UIColor.fromHexaString(hex: "DEDEDE")
                    myCustomCell.dayLabel.textColor = UIColor.gray
                }
            }
//            myCustomCell.selectedView.layer.borderColor = UIColor.gray.cgColor
//            myCustomCell.selectedView.layer.borderWidth = 1
        }else{
            myCustomCell.backgroundColor = UIColor.fromHexaString(hex: "ECECEC")
            myCustomCell.dayLabel.textColor = UIColor.fromHexaString(hex: "ECECEC")
//            myCustomCell.selectedView.layer.borderColor = UIColor.clear.cgColor
//            myCustomCell.selectedView.layer.borderWidth = 0
        }
        if testCalendar.isDateInToday(cellState.date) {
            myCustomCell.backgroundColor = UIColor.fromHexaString(hex: "94D64A")
            myCustomCell.dayLabel.textColor = UIColor.white
        }
        if cellState.isSelected {
            myCustomCell.backgroundColor = UIColor.fromHexaString(hex: "318DDE")
            myCustomCell.dayLabel.textColor = UIColor.white
        }
    }
    func cancelBtnAction(sender: AnyObject) {
        self.customViews.removeFromSuperview()
    }
    
    func okayBtnAction(sender: AnyObject) {
        if(popUpValidationString == "Booked"){
            self.gettingCurrentAppointmentDetails()
        }else if (popUpValidationString == "CancelAppointmentsClear"){
            scheduleAppointment()
    }else if(popUpValidationString == "Cancel Appointment"){
            scheduleAppointment()
        }else if(popUpValidationString == "No Slots Available For This Month."){
            var str1 = ""
            if(typeOfCall == "App Video Consults"){
                 str1 = "Video"
                  }else if(typeOfCall == "App Phone Consults"){
                   str1 = "Phone"
                  }else{
                      
                  }
            callingApi(str: "No \(str1) Appointment-call-\(String(describing: LoadLoginData.phoneNumber))")
            guard let number = URL(string: "tel://" + LoadLoginData.phoneNumber) else { return }
            UIApplication.shared.open(number)
        }
        self.customViews.removeFromSuperview()
    }
}
extension ScheduleAppointmentViewController: JTACMonthViewDelegate, JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.timeZone = testCalendar.timeZone
        formatter.locale = testCalendar.locale
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "MM/dd/yyyy"
        let formattedDate = format.string(from: date)
        let replacedText = replace(myString: formattedDate, 3, "0")
        let replecexText2 = replace(myString: replacedText, 4, "1")
        
        let startDate = formatter.date(from: replecexText2)!
        let endDate = formatter.date(from: "01/01/2024")!
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: numberOfRows,
                                                 calendar: testCalendar,
                                                 generateInDates: generateInDates,
                                                 generateOutDates: generateOutDates,
                                                 firstDayOfWeek: .sunday,
                                                 hasStrictBoundaries: hasStrictBoundaries)
        return parameters
    }
    func configureVisibleCell(myCustomCell: CellView, cellState: CellState, date: Date, indexPath: IndexPath) {
        myCustomCell.dayLabel.text = cellState.text
        
        if date < Calendar.current.date(byAdding: .day, value: -1, to: Date())! {
            myCustomCell.backgroundColor = UIColor.lightText//fromHexaString(hex: "898989")
        }else if testCalendar.isDateInToday(date) {
            myCustomCell.backgroundColor = UIColor.fromHexaString(hex: "94D60A")
        }else{
            myCustomCell.backgroundColor = UIColor.lightText//fromHexaString(hex: "898989")
            myCustomCell.dayLabel.textColor = .black
        }
        if testCalendar.isDateInToday(date) {
            myCustomCell.backgroundColor = UIColor.fromHexaString(hex: "94D60A")
        }
        myCustomCell.imageView.isHidden = true
        if cellState.dateBelongsTo == .thisMonth {
        if(appointmentDate != ""){
            if(callType == validationListResult[0].slotType){
                if Utils.getStringFromDate(date: Utils.getDateFromString(dateStr: appointmentDate, format: "dd-MMM-yyyy"), format: "MM/dd/yyyy") == formatter.string(from: cellState.date) {
                    myCustomCell.imageView.isHidden = false
                } else {
                }
            }
        }
        }
        handleCellConfiguration(cell: myCustomCell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        // This function should have the same code as the cellForItemAt function
        let myCustomCell = cell as! CellView
        configureVisibleCell(myCustomCell: myCustomCell, cellState: cellState, date: date, indexPath: indexPath)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let myCustomCell = calendar.dequeueReusableCell(withReuseIdentifier: "CellView", for: indexPath) as! CellView
        configureVisibleCell(myCustomCell: myCustomCell, cellState: cellState, date: date, indexPath: indexPath)
        return myCustomCell
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        handleCellConfiguration(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        
        let myString = formatter.string(from: cellState.date)
        monthCollectionView.reloadDates([cellState.date])
        selectedCalenderDate = cellState.date
        selectedTempDate = myString
        self.slotTime_Txt.text = "Select Time"
        self.confirmBtnOutlet.isHidden = true
        selectDate(cellState.date)
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        calendar.deselectAllDates()
        self.confirmBtnValidator = false
        selectMonth = true
        setupViewsOfCalendar(from: visibleDates)
        
    }
    
    func calendar(_ calendar: JTACMonthView, willScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.confirmBtnValidator = false
        setupViewsOfCalendar(from: visibleDates)
        
    }
    
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let date = range.start
        let month = testCalendar.component(.month, from: date)
        formatter.dateFormat = "MMM"
        let header: JTACMonthReusableView
        if month % 2 > 0 {
            header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "WhiteSectionHeaderView", for: indexPath)
            (header as! WhiteSectionHeaderView).title.text = formatter.string(from: date)
        } else {
            header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "PinkSectionHeaderView", for: indexPath)
            (header as! PinkSectionHeaderView).title.text = formatter.string(from: date)
        }
        return header
    }
    
    func sizeOfDecorationView(indexPath: IndexPath) -> CGRect {
        let stride = monthCollectionView.frame.width * CGFloat(indexPath.section)
        return CGRect(x: stride + 5, y: 5, width: monthCollectionView.frame.width - 10, height: monthCollectionView.frame.height - 10)
    }
    
    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return monthSize
    }
}
extension ScheduleAppointmentViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tempData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(tempData[row])"
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        pickerView.subviews[1].backgroundColor = UIColor.lightGray
        pickerView.subviews[2].backgroundColor = UIColor.lightGray
        let pickerLabel = UILabel()
        pickerLabel.textColor = (row == pickerView.selectedRow(inComponent: component)) ? UIColor.white : UIColor.gray
        pickerLabel.font = UIFont(name: "Graphie-Regular", size: 22)
        pickerLabel.text = tempData[row]
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        slotTime_Txt.text = "\(tempData[row])"
        self.confirmBtnOutlet.isHidden = false
        //self.confirmBtnOutlet.setTitle("Confirm", for: .normal)
        if tempData[row] == "Select Time" {
            
        }else{
            if(self.alreadyHavingAppointment){
                       popUpValidationString = "Cancel Appointment"
            if(self.validationListResult[0].slotType == "App Video Consults"){
                customViews.loadingData(titleLabl: "Would you like this to replace \n your current appointment?", subTitleLabel: "Currently you have a Video appointment scheduled. You can only schedule one appointment at a time.", cancelBtnTitle: "No", okayBtnTitle: "Yes")
                self.view.addSubview(customViews)
                        }else{
                customViews.loadingData(titleLabl: "Would you like this to replace \n your current appointment?", subTitleLabel: "Currently you have a Phone appointment scheduled. You can only schedule one appointment at a time.", cancelBtnTitle: "No", okayBtnTitle: "Yes")
                self.view.addSubview(customViews)
            }
        }else{
            
        }
        }
    }
    @objc func adjustmentBestSongBpmHeartRate() {
        self.confirmBtnOutlet.setTitle("Join Video Call", for: .normal)
    }
    
}
extension ScheduleAppointmentViewController{
    func scheduleAppointment(){
        var typeOfCall = String()
        if(callType == "App Phone Consults"){
            typeOfCall = "App Phone Consults"
        }else{
            typeOfCall = "App Video Consults"
        }
        var requestDict = [String: String]()
        if(alreadyHavingAppointment){
            requestDict["Email"]    = LoadLoginData.emailID
            requestDict["SelectedDate"]   = Utils.getStringFromDate(date: Utils.getDateFromString(dateStr: validationListResult[0].selectedDate, format: "dd-MMM-yyyy"), format: "MM/dd/yyyy")
            requestDict["Time"]   = validationListResult[0].time
            requestDict["SlotType"] = typeOfCall
            requestDict["Text"] = "Booked"
            requestDict["UserName"] = "MAPP"
        }else{
            requestDict["Email"]    = LoadLoginData.emailID
            requestDict["SelectedDate"]   = Utils.getStringFromDate(date: Utils.getDateFromString(dateStr: selectedTempDate, format: "MM/dd/yyyy"), format: "MM/dd/yyyy")
            requestDict["Time"]   = slotTime_Txt.text
            requestDict["SlotType"] = callType
            requestDict["Text"] = "Available"
            requestDict["UserName"] = "MAPP"
        }
        print(requestDict)
        ApiCall(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.saveNurseShedule.Api, successCallback: {(result) in
            if(result!["Data"] as! String == "Success"){
                self.appointmentDate = ""
                if(self.alreadyHavingAppointment){
                    if(self.validationListResult[0].slotType != ""){
                        if(self.popUpValidationString == "Cancel Appointment"){
                            self.alreadyHavingAppointment = false
                            self.scheduleAppointment()
                        }else{
                        self.confirmBtnOutlet.setTitle("Confirm", for: .normal)
                        self.customViews.loadingData(titleLabl: "", subTitleLabel: "Your appointment has been Cancelled.", cancelBtnTitle: "Ok", okayBtnTitle: "")
                        self.view.addSubview(self.customViews)
                            self.gettingCurrentAppointmentDetails()
                    }
                    }
                    self.alreadyHavingAppointment = false
                    
                }else{
                    self.alreadyHavingAppointment = true
                    self.confirmBtnOutlet.isHidden = false
                    self.confirmBtnOutlet.setTitle("Cancel Appointment", for: .normal)
                    self.popUpValidationString = "Booked"
                    self.customViews.loadingData(titleLabl: "", subTitleLabel: "A confirmation has been sent to your email.", cancelBtnTitle: "", okayBtnTitle: "Ok")
                    self.view.addSubview(self.customViews)
                }
            }else{
                
            }
        }, failureCallback: {(error) in
            self.customViews.loadingData(titleLabl: "", subTitleLabel: errorMessages, cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(self.customViews)
        })
    }
    func selectDate(_ date: Date) {
        tempData.removeAll()
        self.tempDate = date
        
        let df = DateFormatter()
        df.dateFormat = "MM-dd-yyyy"
        
        var requestDict = [String: String]()
        requestDict["date"] = df.string(from: date)
        requestDict["Role"] = "RN"
        requestDict["Module"] = "APP"
        requestDict["SlotType"] = callType
        requestDict["EmailID"] = LoadLoginData.emailID
        
        ApiCalls(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.loadAvailableSlots.Api, successCallback: {(result) in
            if result.count > 0 {
                self.tempData.append("Select Time")
                for results in result{
                    self.tempData.append(results as! String)
                }
                self.pickerView.reloadAllComponents()
            } else {
                
            }
        }, failureCallback: { (error) in
            self.customViews.loadingData(titleLabl: "", subTitleLabel: errorMessages, cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(self.customViews)
        })
    }
    
    func selectMonth(_ date: Date) {
        self.monthCollectionView.reloadData()
        dateObjects.removeAll()
        tempData.removeAll()
        dateArr.removeAll()
        self.tempDate = date
        
        ///////////////////////////////////////////////////
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        
        var requestDict = [String: String]()
        requestDict["date"] = df.string(from: date)
        requestDict["SlotType"] = callType//typeOfCall
        requestDict["EmailID"] = LoadLoginData.emailID
        ApiCalls(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.loadCalenderInfo.Api, successCallback: {(result) in
            if result.count > 0 {
                print(result)
                self.selectMonth = false
                self.dateArr.removeAll()
                let dateFormatter = DateFormatter()
                for date in result{
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let dateObject = Utils.getStringFromDate(date: (dateFormatter.date(from: date as! String)!), format: "MM/dd/yyyy")
                    print(dateObject)
                    self.dateArr.append(dateObject)
                }
                self.monthCollectionView.reloadData()
            }else{
                print("slots not available for this month")
                    self.popUpValidationString = "No Slots Available For This Month."
                 if(LoadLoginData.NSP == "Yes"){
                    self.customViews.loadingData(titleLabl: "", subTitleLabel: "No appointments available in this month.", cancelBtnTitle: "Okay", okayBtnTitle: "")
                    self.view.addSubview(self.customViews)
                 }else{
                    self.customViews.loadingData(titleLabl: "", subTitleLabel: "No appointments available in this month.", cancelBtnTitle: "Cancel", okayBtnTitle: "Call Now")
                self.view.addSubview(self.customViews)
                }
            }
        }, failureCallback: {(error) in
            self.customViews.loadingData(titleLabl: "", subTitleLabel: errorMessages, cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(self.customViews)
        })
    }
    func GetTwilioToken(){
        var responceDict = [String: String]()
        responceDict["Room"] = validationListResult[0].videoRoomName
        responceDict["Name"] = validationListResult[0].memberID
        ApiCall(requestDict: responceDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.getTwilioToken.Api, successCallback: {(result) in
            if result != nil {
                twilioTokenId = result!["Data"] as! String
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "VideoChatViewController") as? VideoChatViewController
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }, failureCallback: {(error) in
            self.customViews.loadingData(titleLabl: "", subTitleLabel: errorMessages, cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(self.customViews)
        })
    }
    func gettingCurrentAppointmentDetails(){
        MemberIDs = ""
        VideoRoomName = ""
        var requestDict = [String:String]()
        requestDict["Email"] = LoadLoginData.emailID
        ApiCalls(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.validationList.Api, successCallback: {(result)  in
            self.validationListResult.removeAll()
            if result.count > 0 {
                for i in 0...result.count - 1 {
                    let dataObject = validationList.init(json: result[i] as! Dictionary<String, AnyObject>)
                    self.validationListResult.append(dataObject)
                }
                if let appointmentDate1 = self.validationListResult[0].selectedDate {
                    self.appointmentDate = appointmentDate1
                }
                if(callType == self.validationListResult[0].slotType){
                    self.confirmBtnOutlet.setTitle("Cancel Appointment", for: .normal)
                }else{
                    
                }
                MemberIDs = self.validationListResult[0].memberID
                VideoRoomName = self.validationListResult[0].videoRoomName
                if(self.validationListResult[0].slotType == "App Phone Consults"){
                    if(callType == "App Phone Consults"){
                        let appointmentDate = Utils.getStringFromDate(date: Utils.getDateFromString(dateStr: self.validationListResult[0].selectedDate, format: "dd-MMM-yyyy"), format: "MMMM yyyy")
                        if(self.monthTitle_Lbl.text == appointmentDate){
                        self.slotTime_Txt.text = self.validationListResult[0].time
                        self.confirmBtnOutlet.isHidden = false
                        }else{
                            self.confirmBtnOutlet.isHidden = true
                            self.slotTime_Txt.text = "Select Time"
                        }
                    }else{
                        self.confirmBtnOutlet.isHidden = true
                        self.slotTime_Txt.text = "Select Time"
                    }
                    
                    //                           self.viewCurrentAppointment_Lbl.text = "You have a Phone Appointment Scheduled."
                }else if(self.validationListResult[0].slotType == "App Video Consults"){
                    if(callType == "App Video Consults"){
                        self.timer = Timer.scheduledTimer(timeInterval: NumberFormatter().number(from: self.validationListResult[0].timerDuration) as! TimeInterval, target: self, selector: #selector(self.adjustmentBestSongBpmHeartRate), userInfo: nil, repeats: false)
                        let appointmentDate = Utils.getStringFromDate(date: Date(), format: "MMMM yyyy")
                        if(self.monthTitle_Lbl.text == appointmentDate){
                        self.slotTime_Txt.text = self.validationListResult[0].time
                        self.confirmBtnOutlet.isHidden = false
                        }else{
                            self.confirmBtnOutlet.isHidden = true
                            self.slotTime_Txt.text = "Select Time"
                        }
                    }else{
                        self.confirmBtnOutlet.isHidden = true
                        self.slotTime_Txt.text = "Select Time"
                    }
                    //                           self.viewCurrentAppointment_Lbl.text = "You have a Video Appointment Scheduled."
                }else{
                    
                }
                _ = Timer(timeInterval: NumberFormatter().number(from: self.validationListResult[0].timerDuration!) as! TimeInterval, repeats: true) { _ in
                    self.confirmBtnOutlet.setTitle("Join Video Call", for: .normal)
                }
                self.alreadyHavingAppointment = true
                self.monthCollectionView.reloadData()
                print("Validations List having some data")
            }else{
                self.alreadyHavingAppointment = false
                self.confirmBtnOutlet.setTitle("Confirm", for: .normal)
                self.confirmBtnOutlet.isHidden = true
                self.slotTime_Txt.text = "Select Time"
                self.validationListResult.removeAll()
                self.monthCollectionView.reloadData()
                print("Validations List is Empty")
            }
        }, failureCallback: {(errorMsg) in
            self.customViews.loadingData(titleLabl: "", subTitleLabel: errorMessages, cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(self.customViews)
        })
    }
}
class CellView: JTACDayCell {
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
}
class WhiteSectionHeaderView: JTACMonthReusableView {
    @IBOutlet weak var title: UILabel!
}
class PinkSectionHeaderView: JTACMonthReusableView {
    @IBOutlet var title: UILabel!
}
