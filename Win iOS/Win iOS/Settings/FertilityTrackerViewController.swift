//
//  FertilityTrackerViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 03/02/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

var selectedDateNotes:Date? = nil
var dateValidator = ""


import UIKit
import JTAppleCalendar

class FertilityTrackerViewController: UIViewController {

    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var title_Lbl: UILabel!
    @IBOutlet weak var monthTitle_Lbl: UILabel!
    @IBOutlet weak var calenderView: JTACMonthView!
    
    var calNextCycleDataCollection:[String]? = []
    var calReminderDataCollection:[String]? = []
    var calCycleDataCollection:[String]? = []
    var calMonthlyCycleDataCollection:[String]? = []
    var calEventsDataCollection:[String]? = []
    var calOvulationCycleDataCollection:[String]? = []
    
    var numberOfRows = 6
    var monthSize: MonthSize? = nil
    var generateInDates: InDateCellGeneration = .forAllMonths
    var generateOutDates: OutDateCellGeneration = .tillEndOfGrid
    var prePostVisibility: ((CellState, CellView?)->())?
    var currentScrollModeIndex = 0
    var presentCalendar = Calendar.current
    var todayDate = Date()
    let formatter = DateFormatter()
    var hasStrictBoundaries = true
    let allScrollModes: [ScrollingMode] = [
        .none,
        .nonStopTo(customInterval: 374, withResistance: 0.5),
        .nonStopToCell(withResistance: 0.5),
        .nonStopToSection(withResistance: 0.5),
        .stopAtEach(customInterval: 374),
        .stopAtEachCalendarFrame,
        .stopAtEachSection
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calenderView.register(UINib(nibName: "PinkSectionHeaderView", bundle: Bundle.main),
                              forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                              withReuseIdentifier: "PinkSectionHeaderView")
        
        self.calenderView.scrollToDate(Date())
        self.calenderView.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
        setupScrollMode()
        self.calenderView.scrollToDate(Date())
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
        presentIndex = "5"
        self.tabbar.selectedItem = tabbar.items?[4]
        }
        let currentDate = Utils.getStringFromDate(date: todayDate , format: "MM/dd/yyyy")
        loadCalendarData(date: currentDate)
        calenderView.minimumLineSpacing = 1
        calenderView.minimumInteritemSpacing = 1
        self.calenderView.reloadData()
    }
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.backToViewController(viewController: HomeViewController.self)
    }
    @IBAction func previousMonthBtnClick(_ sender: Any) {
        self.calenderView.scrollToSegment(.previous)
    }
    @IBAction func nextBtnClick(_ sender: Any) {
        self.calenderView.scrollToSegment(.next)
    }
    func setupScrollMode() {
        currentScrollModeIndex = 6
        calenderView.scrollingMode = allScrollModes[currentScrollModeIndex]
    }
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first?.date else {
            return
        }
        let month = presentCalendar.dateComponents([.month], from: startDate).month!
        let monthName = DateFormatter().monthSymbols[(month-1) % 12]
        let year = presentCalendar.component(.year, from: startDate)
        monthTitle_Lbl.text = monthName + " " + String(year)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        let currentDate = Utils.getStringFromDate(date: startDate , format: "MM/dd/yyyy")
        loadCalendarData(date: currentDate)
    }
    func handleCellConfiguration(cell: JTACDayCell?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
        prePostVisibility?(cellState, cell as? CellView)
    }
    func handleCellSelection(view: JTACDayCell?, cellState: CellState) {
           guard let myCustomCell = view as? CellCycle else {return }
           if cellState.isSelected {
               myCustomCell.backgroundColor = UIColor.white
           }else{
           }
           if cellState.dateBelongsTo == .thisMonth {
               if cellState.date >= Date() {
                   myCustomCell.backgroundColor = UIColor.white
                   myCustomCell.dayLabel.textColor = UIColor.gray
               }else{
                   myCustomCell.isHidden = false
                   myCustomCell.backgroundColor = UIColor.fromHexaString(hex: "EBEBEB")
                   myCustomCell.dayLabel.textColor = UIColor.gray
               }
            print("please check the date here \(calReminderDataCollection!.contains( formatter.string(from: cellState.date))) ---- \(formatter.string(from: cellState.date))")
            if calEventsDataCollection!.contains( formatter.string(from: cellState.date)) {
                //myCustomCell.backgroundColor = UIColor.fromHexaString(hex: "8C85CB")
                myCustomCell.imageView.isHidden = false
            }
            if calReminderDataCollection!.contains( formatter.string(from: cellState.date)) {
                myCustomCell.imageView.isHidden = false
            }
               if calNextCycleDataCollection!.contains( formatter.string(from: cellState.date)) {
                   print("\(formatter.string(from: cellState.date))")
                   myCustomCell.backgroundColor = UIColor.fromHexaString(hex: "8C85CB")
                   myCustomCell.dayLabel.textColor = UIColor.white
               }else if calCycleDataCollection!.contains( formatter.string(from: cellState.date)) {
                   myCustomCell.backgroundColor = UIColor.fromHexaString(hex: "8C85CB")
                   myCustomCell.dayLabel.textColor = UIColor.white
               }else if calMonthlyCycleDataCollection!.contains( formatter.string(from: cellState.date)) {
                   myCustomCell.backgroundColor = UIColor.fromHexaString(hex: "8C85CB")
                   myCustomCell.dayLabel.textColor = UIColor.white
               }else if calOvulationCycleDataCollection!.contains( formatter.string(from: cellState.date)) {
                   myCustomCell.backgroundColor = UIColor.fromHexaString(hex: "E084BC")
                   myCustomCell.dayLabel.textColor = UIColor.white
               }else {
               }
           } else {
               //myCustomCell.isUserInteractionEnabled = false
               myCustomCell.backgroundColor = UIColor.fromHexaString(hex: "F7F7F7")
               myCustomCell.dayLabel.textColor = UIColor.lightGray
           }
           if presentCalendar.isDateInToday(cellState.date) {
               myCustomCell.backgroundColor = UIColor.fromHexaString(hex: "94D64A")
               myCustomCell.dayLabel.textColor = UIColor.white
           }
       }
}
extension FertilityTrackerViewController: JTACMonthViewDelegate, JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        
        formatter.dateFormat = "MM/dd/YYYY"
        formatter.timeZone = presentCalendar.timeZone
        formatter.locale = presentCalendar.locale
        let startDate = formatter.date(from: "01/01/2018")!
        let endDate = formatter.date(from: "01/01/2021")!
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: numberOfRows,
                                                 calendar: presentCalendar,
                                                 generateInDates: generateInDates,
                                                 generateOutDates: generateOutDates,
                                                 firstDayOfWeek: .sunday,
                                                 hasStrictBoundaries: hasStrictBoundaries)
        return parameters
    }
    func configureVisibleCell(myCustomCell: CellCycle, cellState: CellState, date: Date, indexPath: IndexPath) {
        myCustomCell.dayLabel.text = cellState.text
        myCustomCell.imageView.isHidden = true
        if date < Calendar.current.date(byAdding: .day, value: -1, to: Date())! {
            myCustomCell.backgroundColor = UIColor.lightText//fromHexaString(hex: "898989")
        }else if presentCalendar.isDateInToday(date) {
            myCustomCell.backgroundColor = UIColor.fromHexaString(hex: "94D60A")
            myCustomCell.dayLabel.textColor = UIColor.white
        }else{
            myCustomCell.backgroundColor = UIColor.lightText
            myCustomCell.dayLabel.textColor = UIColor.black
        }
        handleCellConfiguration(cell: myCustomCell, cellState: cellState)
        
        if cellState.text == "1" {
            todayDate = Calendar.current.date(byAdding: .day, value: -10, to: cellState.date)!
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/YYYY"
            let month = formatter.string(from: date)
            let datea = formatter.date(from: month)
            print(datea)
        } else {
        
        }
    }
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let myCustomCell = cell as! CellCycle
        configureVisibleCell(myCustomCell: myCustomCell, cellState: cellState, date: date, indexPath: indexPath)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let myCustomCell = calendar.dequeueReusableCell(withReuseIdentifier: "CellView1", for: indexPath) as! CellCycle
        configureVisibleCell(myCustomCell: myCustomCell, cellState: cellState, date: date, indexPath: indexPath)
        return myCustomCell
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        handleCellConfiguration(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        selectedDateNotes = cellState.date
        if(cellState.date.isAfterDate(Date())){
            dateValidator = "fetureDate"
        }else if(cellState.date.isBeforeDate(Date())){
            dateValidator = "pastDate"
        }else if(cellState.date.isSameDate(Date())){
            dateValidator = "toDay"
        }else{
            
        }
       let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlertsAndNotesViewController") as! AlertsAndNotesViewController
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
    
    func calendar(_ calendar: JTACMonthView, willScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
        
    }
    
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let date = range.start
        let month = presentCalendar.component(.month, from: date)
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
        let stride = calenderView.frame.width * CGFloat(indexPath.section)
        return CGRect(x: stride + 5, y: 5, width: calenderView.frame.width - 10, height: calenderView.frame.height - 10)
    }
    
    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return monthSize
    }
}
extension FertilityTrackerViewController {
    func loadCalendarData(date: String) {
        var requestDict = [String: String]()
        requestDict["EmailID"] = LoadLoginData.emailID
        requestDict["Date"] = date
        ApiCall(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.loadCalenderData.Api, successCallback: {(result) in
            if let calenderData = result {
            if let monthlyCycleData = calenderData["MonthlyCycle"] as? String{
            self.calMonthlyCycleDataCollection = (monthlyCycleData).components(separatedBy: ",")
            }
            if let currentCycleData = calenderData["CurrentCycle"] as? String{
            self.calCycleDataCollection = (currentCycleData).components(separatedBy: ",")
            }
            if let nextCycleData = calenderData["NextCycle"] as? String{
            self.calNextCycleDataCollection = (nextCycleData).components(separatedBy: ",")
            }
            if let ovulationCycleData = calenderData["OvulationCycle"] as? String{
            self.calOvulationCycleDataCollection = (ovulationCycleData).components(separatedBy: ",")
            }
            if let ovulationCycleData = calenderData["ReminderDate"] as? String{
            self.calReminderDataCollection = (ovulationCycleData).components(separatedBy: ",")
            }
            if let ovulationCycleData = calenderData["EventDate"] as? String{
            self.calEventsDataCollection = (ovulationCycleData).components(separatedBy: ",")
            }
            if let periodCountDown = calenderData["PeriodCountdown"]{
                print(periodCountDown)
            }
            if let ovulationCountDown = calenderData["OvulationCountdown"]{
            self.title_Lbl.text = "\(ovulationCountDown) Days Until Fertility Window"
            }
            }
            self.calenderView.reloadData()
        }, failureCallback: {(error) in

        })
    }
}
class CellCycle: JTACDayCell {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
}
