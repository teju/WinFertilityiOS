//
//  AccumulatorViewController.swift
//  Win iOS
//
//  Created by ISE10121 on 28/01/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit

class AccumulatorViewController: UIViewController, customViewDelegate {
    func cancelBtnAction(sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func okayBtnAction(sender: AnyObject) {
        print("Okay btn clicked")
    }
    

    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var benefits_Lbl: UILabel!
    @IBOutlet weak var used_Lbl: UILabel!
    @IBOutlet weak var remaining_Lbl: UILabel!
    var customView = CustomView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customView.customViewDelegates = self
        getSeverData()
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
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareBtnAction(_ sender: Any) {
        shareAccumulatorData()
    }
    func getSeverData(){
            var requestDict = [String: String]()
        requestDict["EmailID"] = LoadLoginData.emailID
        ApiCalls(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.getAccumulatorDetails.Api, successCallback: {(result) in
            if (result.count > 0) {
                var data0 = NumberFormatter().number(from: (result.value(forKey: "Benefit") as! NSArray)[0] as! String)
                var data1 = NumberFormatter().number(from: (result.value(forKey: "Used") as! NSArray)[0] as! String)
                var data2 = NumberFormatter().number(from: (result.value(forKey: "Remaining") as! NSArray)[0] as! String)

                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .currency
                if data0 == nil {
                    data0 = 0
                }
                if data1 == nil {
                    data1 = 0
                }
                if data2 == nil {
                    data2 = 0
                }
                    self.benefits_Lbl.text = "\(String(describing: numberFormatter.string(from: data0!)!))"
                    self.used_Lbl.text = "\(String(describing: numberFormatter.string(from: data1!)!))"
                    self.remaining_Lbl.text = "\(String(describing: numberFormatter.string(from: data2!)!))"

                let pieChartView = PieChartView()
                pieChartView.frame = CGRect(x: 0, y: 0, width: self.chartView.frame.size.width, height: self.chartView.frame.size.height)
                pieChartView.segments = [
                    Segment(color: UIColor.fromHexaString(hex: "16284C"), value: CGFloat(truncating: data2!)),
                    Segment(color: UIColor.fromHexaString(hex: "318DDE"), value: CGFloat(truncating: data1!))
                ]
                self.chartView.addSubview(pieChartView)
                }else{
                    
                }
            }, failureCallback: {(error) in
                self.customView.loadingData(titleLabl: "", subTitleLabel: errorMessages, cancelBtnTitle: "Okay", okayBtnTitle: "")
                self.view.addSubview(self.customView)
            })
    }
    func shareAccumulatorData(){
        var requestDict = [String: String]()
        requestDict["EmailID"]     = LoadLoginData.emailID
        ApiCall(requestDict: requestDict, apiMethod: NWHTTPMethod.post.rawValue, url: ApiMethodsName.exportAccumulator.Api, successCallback: {(result) in
            print(result)
            self.customView.loadingData(titleLabl: "", subTitleLabel: "Successfully exported your Accumulator data.", cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(self.customView)
            //Optional(["Result": 1, "Message": Successful])
        }, failureCallback: {(error) in
            self.customView.loadingData(titleLabl: "", subTitleLabel: errorMessages, cancelBtnTitle: "Okay", okayBtnTitle: "")
            self.view.addSubview(self.customView)
        })
    }
}


struct Segment {

    // the color of a given segment
    var color: UIColor

    // the value of a given segment – will be used to automatically calculate a ratio
    var value: CGFloat
}

class PieChartView: UIView {

    /// An array of structs representing the segments of the pie chart
    var segments = [Segment]() {
        didSet {
            setNeedsDisplay() // re-draw view when the values get set
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false // when overriding drawRect, you must specify this to maintain transparency.
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {

        // get current context
        let ctx = UIGraphicsGetCurrentContext()

        // radius is the half the frame's width or height (whichever is smallest)
        let radius = min(frame.size.width, frame.size.height) * 0.5

        // center of the view
        let viewCenter = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)

        // enumerate the total value of the segments by using reduce to sum them
        let valueCount = segments.reduce(0, {$0 + $1.value})

        // the starting angle is -90 degrees (top of the circle, as the context is flipped). By default, 0 is the right hand side of the circle, with the positive angle being in an anti-clockwise direction (same as a unit circle in maths).
        var startAngle = -CGFloat.pi * 0.5

        for segment in segments { // loop through the values array

            // set fill color to the segment color
            ctx?.setFillColor(segment.color.cgColor)

            // update the end angle of the segment
            let endAngle = startAngle + 2 * .pi * (segment.value / valueCount)

            // move to the center of the pie chart
            ctx?.move(to: viewCenter)

            // add arc from the center for each segment (anticlockwise is specified for the arc, but as the view flips the context, it will produce a clockwise arc)
            ctx?.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)

            // fill segment
            ctx?.fillPath()

            // update starting angle of the next segment to the ending angle of this segment
            startAngle = endAngle
        }
    }
}
