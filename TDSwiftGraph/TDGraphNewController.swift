//
//  TDGraphNewController.swift
//  TDSwiftGraph
//
//  Created by Tieshow Daniels on 4/17/17.
//  Copyright © 2017 Ty Daniels. All rights reserved.
//

import Foundation
import UIKit
import CorePlot
import Stevia

class TDGraphNewController: TDGraphBaseViewController, UIToolbarDelegate {
    
    var toolbarTimePeriod = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolbarTimePeriod.delegate = self
        
        setupView()
    }
    
    // MARK: - Graph layout which dictates layout of objects from parent (base)
    
    fileprivate func setupView() {

        view.sv(graphView, toolbarTimePeriod)
        view.layout(
            130,
            |graphView| ~ view.frame.height / 2,
            0,
            |toolbarTimePeriod| ~ 33
        )
        
        //MARK: - Additional layouts
        
        graphView.backgroundColor = UIColor.lightGray
        
        let barItemAttributes = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 15.0)]
        barButtonItem1D.setTitleTextAttributes(barItemAttributes, for: UIControlState.normal)
        barButtonItem1M.setTitleTextAttributes(barItemAttributes, for: UIControlState.normal)
        barButtonItem3M.setTitleTextAttributes(barItemAttributes, for: UIControlState.normal)
        barButtonItem6M.setTitleTextAttributes(barItemAttributes, for: UIControlState.normal)
        barButtonItem1Y.setTitleTextAttributes(barItemAttributes, for: UIControlState.normal)
        
        
        barButtonItem1D.title = "1 Day"
        barButtonItem1M.title = "1 Month"
        barButtonItem3M.title = "3 Months"
        barButtonItem6M.title = "6 Months"
        barButtonItem1Y.title = "1 Year"
        
        barButtonItem1D.action = #selector(onBarButtonItem1D)
        barButtonItem1M.action = #selector(onBarButtonItem1M)
        barButtonItem3M.action = #selector(onBarButtonItem3M)
        barButtonItem6M.action = #selector(onBarButtonItem6M)
        barButtonItem1Y.action = #selector(onBarButtonItem1Y)
        
        toolbarTimePeriod.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        toolbarTimePeriod.setShadowImage(UIImage(), forToolbarPosition: .any)
        toolbarTimePeriod.backgroundColor = UIColor.blue
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        flexSpace.width = 10
        let toolBarItems = [flexSpace, barButtonItem1D, barButtonItem1M, barButtonItem3M, barButtonItem6M, barButtonItem1Y]
        toolbarTimePeriod.items = toolBarItems
    }
    
    
    func onBarButtonItem1D() {
        selectedDataIndex = CustomTimeInterval.Day
        getData()
        print(selectedDataIndex)
    }
    func onBarButtonItem1M() {
        selectedDataIndex = CustomTimeInterval.Month
        getData()
        print(selectedDataIndex)
    }
    func onBarButtonItem3M() {
        selectedDataIndex = CustomTimeInterval.Month3
        getData()
    }
    func onBarButtonItem6M() {
        selectedDataIndex = CustomTimeInterval.Month6
        getData()
    }
    func onBarButtonItem1Y() {
        selectedDataIndex = CustomTimeInterval.Year
        getData()
    }
    
    
    //From SessaGraphBaseViewController
    override func formatLabelSelectedPoint(showDate:Bool){
        //$8.27 | 0.00 | 0.00% 11/17/15, 04:01 PM
        dateFormatter.dateFormat = selectedDataIndex != CustomTimeInterval.Day || selectedIndex==0 ? "MM/dd/yyyy" : "h:mm a"
        let firstValue = data.y.first! + self.additionalValueY + self.additionalDisplayValue
        let selectedBalance = data.y1[Int(selectedIndex!)] + data.balance[Int(selectedIndex!)]
        //let sharesCost = data.y1[Int(selectedIndex!)]
        let firstBalance = data.balance.filter({ (res) -> Bool in
            return res > 0.000001
        }).first ?? 0.000001
        let firstSharesCost = data.y1.filter({ (res) -> Bool in
            return res > 0.000001
        }).first ?? 0.000001
        let firstCost = firstSharesCost + firstBalance
        let selectedDate = NSDate(timeIntervalSince1970: data.x[Int(selectedIndex!)])
        
//        userNameLabel.text = User.instance.name
//        userNameLabel.textColor = UIColor.white
//        userNameLabel.font = UIFont.FreightSansProSemiboldRegular(sizeFont: 17)
        
        labelMainSelectedValue.text = String(format: "$%.2f", selectedBalance)
        
        let dateString = showDate ? String(format: "%@", arguments: [dateFormatter.string(from: selectedDate as Date)]) : ""
        let selectedValue = data.y[Int(selectedIndex!)] + self.additionalValueY
        let diffChar = selectedValue > 0 ? "+" : ""
        var selectedPointText = ""
        if firstCost > 0.0001 {
            selectedPointText = String(format: "%@%.2f%% %@%.2f %@", arguments: [diffChar, (selectedValue - firstValue)/firstCost * 100.0, diffChar, selectedValue, dateString])
        } else {
            selectedPointText = String(format: "%@%.2f%% %@%.2f %@", arguments: [diffChar, 0.0, diffChar, selectedValue, dateString])
        }
        let spaceMark: Character = " "
        let indexSpace = selectedPointText.indexOfCharacter(char: spaceMark)
        
        labelSelectedPoint.font = UIFont.boldSystemFont(ofSize: 22)
        labelSelectedPoint.textColor = UIColor.white
        
        let attributedText = NSMutableAttributedString(string: selectedPointText)
        attributedText.setAttributes([NSForegroundColorAttributeName : UIColor.cyan], range: NSMakeRange(0, indexSpace!))
        labelSelectedPoint.attributedText = attributedText
    }
    
    // Disable swipe for parent viewcontroller while the embedded graph points are discovered
    
    override func plotSpace(_ space: CPTPlotSpace, shouldHandlePointingDeviceDraggedEvent event: UIEvent, at point: CGPoint) -> Bool {
//        (self.parent as? UserPortfolioViewController)?.userHoldingsTable.isScrollEnabled = false
        //        (self.parentViewController as? UserPortfolioViewController)?.tabBarController?.swipeDisable = true
        return super.plotSpace(space, shouldHandlePointingDeviceDraggedEvent: event, at: point)
    }
    
    override func plotSpace(_ space: CPTPlotSpace, shouldHandlePointingDeviceUp event: UIEvent, at point: CGPoint) -> Bool {
//        (self.parent as? UserPortfolioViewController)?.userHoldingsTable.isScrollEnabled = true
        //        (self.parentViewController as? UserPortfolioViewController)?.tabBarController?.swipeDisable = false
        return super.plotSpace(space, shouldHandlePointingDeviceDraggedEvent: event, at: point)
    }
    
    override func loadGraph(data: (x: [Double], y: [Double], y1: [Double], balance: [Double]), allPoints: Bool) {
        
        super.loadGraph(data: data, allPoints: allPoints)
    }
    
}


