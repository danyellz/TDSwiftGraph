//
//  TDBaseGraphController.swift
//  TDSwiftGraph
//
//  Created by Tieshow Daniels on 4/17/17.
//  Copyright © 2017 Ty Daniels. All rights reserved.
//

import UIKit
import CorePlot
import Stevia

protocol TDGraphViewControllerDataSource {
    func dataForGraph(section: Int, completionHandler: @ escaping (_ prices:(x:[Double],y:[Double],y1:[Double],balance:[Double]), _ allPoints: Bool) -> Void) -> Void
}

class TDGraphBaseViewController: UIViewController {
    
    var barButtonItem1D = UIBarButtonItem()
    var barButtonItem1M = UIBarButtonItem()
    var barButtonItem3M = UIBarButtonItem()
    var barButtonItem6M = UIBarButtonItem()
    var barButtonItem1Y = UIBarButtonItem()
    
    var viewContainerGraph = UIView()
    var labelSelectedPoint = UILabel()
    var graphView = CPTGraphHostingView()
    var userGraph = false
    
    var labelChartNotAvailable: UILabel = UILabel()
    var selectedDataIndex: CustomTimeInterval = CustomTimeInterval.Day {
        didSet{
            maketBarItemSelected(index: selectedDataIndex.rawValue)
        }
    }
    var fromWatchlist = false
    
    var userNameLabel: UILabel = UILabel()
    var mainLabelView: UIView = UIView()
    var labelMainSelectedValue: UILabel = UILabel()
    
    var dataSource: TDGraphViewControllerDataSource?
    var data: (x:[Double], y:[Double], y1:[Double], balance:[Double]) = (x:[], y:[], y1:[], balance:[])
    var dataArray = [Int: (x:[Double], y:[Double], y1:[Double], balance:[Double])]()
    var isAllPoints = true
    var isAllPointsArray = [Int: Bool]()
    var graph = CPTXYGraph(frame: CGRect.zero)
    var maxX = 0.00
    var plot = CPTScatterPlot()
    let selectionPlot = CPTScatterPlot()
    let areaSelectionPlot = CPTScatterPlot()
    var zeroLine = CPTScatterPlot()
    var hideousLine = CPTScatterPlot()
    var hideousLine2 = CPTScatterPlot()
    var selectedIndex: UInt? = nil
    let idMainPlot = "main_plot"
    let idSelectedPoint = "selected_point"
    let idAreaSelectedPoint = "area_selected_point"
    let idZeroLine = "zeroLine"
    let idHideous1DLine = "idHideous1DLine"
    let maxPointsFor1D = 80
    //var mainTitle:String?
    static let coloredTextAttributes = [NSForegroundColorAttributeName : UIColor.blue, NSFontAttributeName : UIFont.boldSystemFont(ofSize: 20)]
    
    let dateFormatter = DateFormatter()
    var additionalValueY:Double = 0
    var zeroLineValueY:Double = 0
    
    var additionalDisplayValue: Double = 0
    
    var distance: Double = 0
    
    let mainLineColor = CPTColor(componentRed: 38.0/255.0, green: 148.0/255.0, blue: 171.0/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGraphView()
        
        labelMainSelectedValue.font = UIFont.boldSystemFont(ofSize: 64)
        labelMainSelectedValue.textColor = UIColor.blue
        
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        
        //        graph = CPTXYGraph(frame: CGRect(x: 0, y: 0, width: graphView.frame.width, height: graphView.frame.height))
        graph.axisSet = nil
        // hide paddings
        graph.paddingLeft = 0.0
        graph.paddingTop = 0.0
        graph.paddingRight = 0.0
        graph.paddingBottom = 0.0
        
        //Plot to fill area in 1D graph
        hideousLine.dataSource = self
        hideousLine.identifier = idHideous1DLine as (NSCoding & NSCopying & NSObjectProtocol)?
        let hideousLineStyle = CPTMutableLineStyle()
        hideousLineStyle.lineWidth = 2.5
        hideousLineStyle.lineColor = CPTColor(componentRed: 0, green: 0, blue: 0, alpha: 0.0)
        hideousLine.dataLineStyle = hideousLineStyle
        hideousLine.areaBaseValue = NSNumber(value: 2.0)
        hideousLine.areaBaseValue2 = NSNumber(value: -2.0)
        hideousLine.areaFill = CPTFill(color: CPTColor(cgColor: UIColor.blue.cgColor))
        graph.add(hideousLine)
        
        hideousLine2.dataSource = self
        hideousLine2.identifier = idHideous1DLine as (NSCoding & NSCopying & NSObjectProtocol)?
        let hideousLineStyle2 = CPTMutableLineStyle()
        hideousLineStyle2.lineWidth = 2.5
        hideousLineStyle2.lineColor = CPTColor(componentRed: 0, green: 0, blue: 0, alpha: 0.0)
        hideousLine2.dataLineStyle = hideousLineStyle2
        hideousLine2.areaBaseValue = NSNumber(value: -2.0)
        hideousLine2.areaFill = CPTFill(color: CPTColor(cgColor: UIColor.blue.cgColor))
        graph.add(hideousLine2)
        
        //main plot
        let lineStyle = CPTMutableLineStyle()
        lineStyle.lineWidth = 2.5
        lineStyle.lineColor = mainLineColor
        plot.identifier = idMainPlot as (NSCoding & NSCopying & NSObjectProtocol)?
        plot.dataLineStyle = lineStyle
        plot.dataSource = self
        plot.delegate = self
        plot.plotSymbolMarginForHitDetection = 10
        plot.paddingLeft = 0.0
        plot.paddingTop = 0.0
        plot.paddingRight = 0.0
        plot.paddingBottom = 0.0
        plot.areaBaseValue = NSNumber(value: 2.0)
        plot.areaFill = CPTFill(color: CPTColor(cgColor: UIColor.blue.cgColor))
        graph.add(plot)
        
        
        //zero line
        zeroLine.dataSource = self
        zeroLine.identifier = idZeroLine as (NSCoding & NSCopying & NSObjectProtocol)?
        let zeroLineStyle = CPTMutableLineStyle()
        zeroLineStyle.lineWidth = 2.5
        zeroLineStyle.lineColor = mainLineColor
        zeroLineStyle.dashPattern = [NSNumber(cgFloat: 3), NSNumber(cgFloat: 3)]
        zeroLine.dataLineStyle = zeroLineStyle
        graph.add(zeroLine)
        
        // Selection Marker Area
        areaSelectionPlot.dataSource = self
        areaSelectionPlot.identifier = idAreaSelectedPoint as (NSCoding & NSCopying & NSObjectProtocol)?
        areaSelectionPlot.cachePrecision = CPTPlotCachePrecision.double
        let lineAreaStyleSelectionPoint = CPTMutableLineStyle()
        lineAreaStyleSelectionPoint.lineWidth = 0.0
        lineAreaStyleSelectionPoint.lineColor = mainLineColor
        areaSelectionPlot.dataLineStyle = lineAreaStyleSelectionPoint
        graph.add(self.areaSelectionPlot)
        
        // Selection Marker
        selectionPlot.identifier = idSelectedPoint as (NSCoding & NSCopying & NSObjectProtocol)?
        selectionPlot.cachePrecision = CPTPlotCachePrecision.double
        let lineStyleSelectionPoint = CPTMutableLineStyle()
        lineStyleSelectionPoint.lineWidth = 3.0
        lineStyleSelectionPoint.lineColor = mainLineColor
        selectionPlot.dataLineStyle = lineStyleSelectionPoint
        selectionPlot.dataSource = self
        graph.add(selectionPlot)
        
        graphView.hostedGraph = graph
        if !fromWatchlist{
            maketBarItemSelected(index: 0)
        }else{
            selectedDataIndex = CustomTimeInterval.Year
            maketBarItemSelected(index: 4)
            
        }
        
        labelMainSelectedValue.text = ""
        graph.defaultPlotSpace?.delegate = self
        getData()
    }
    
    func maketBarItemSelected(index: Int) -> Void {
        barButtonItem1D.tintColor = UIColor.white
        barButtonItem1M.tintColor = UIColor.white
        barButtonItem3M.tintColor = UIColor.white
        barButtonItem6M.tintColor = UIColor.white
        barButtonItem1Y.tintColor = UIColor.white
        switch index {
        case 0:
            barButtonItem1D.tintColor = mainLineColor.uiColor
            break
        case 1:
            barButtonItem1M.tintColor = mainLineColor.uiColor
            break
        case 2:
            barButtonItem3M.tintColor = mainLineColor.uiColor
            break
        case 3:
            barButtonItem6M.tintColor = mainLineColor.uiColor
            break
        case 4:
            barButtonItem1Y.tintColor = mainLineColor.uiColor
            break
        default:
            break
        }
    }
    
    func setupGraphView() {
        view.sv(mainLabelView.sv(userNameLabel, labelMainSelectedValue,
                                 labelSelectedPoint)
        )
        view.layout(
            0,
            |mainLabelView| ~ 130
        )
        
        mainLabelView.layout(
            0,
            |-userNameLabel-| ~ 20,
            0,
            |-labelMainSelectedValue-| ~ 65,
            0,
            |-labelSelectedPoint-| ~ 25
        )
        
        userNameLabel.backgroundColor = UIColor.darkGray
        userNameLabel.textAlignment = .center
        
        mainLabelView.backgroundColor = UIColor.darkGray
        
        labelMainSelectedValue.textAlignment = .center
        labelSelectedPoint.textAlignment = .center
    }
    
    
    func setRangeForGraph(){
        // Get the (default) plotspace from the graph so we can set its x/y ranges
        let plotSpace = graph.defaultPlotSpace as! CPTXYPlotSpace
        // Note that these CPTPlotRange are defined by START and LENGTH (not START and END) !!
        let minX = 0.00
        maxX = selectedDataIndex != CustomTimeInterval.Day ? Double(data.x.count-1) : Double(data.x.count)//self.data.x.maxElement() ?? 0.00
        if(selectedDataIndex == .Day) {
            if !isAllPoints {
                maxX = Double((data.x.count <= maxPointsFor1D ? maxPointsFor1D : data.x.count)-1 )
            }
        }
        let lengthX = maxX - minX
        let decLocX = NSDecimalNumber(cgFloat: CGFloat(minX))
        let decLength = NSDecimalNumber(cgFloat: CGFloat(lengthX))
        let xRange = CPTPlotRange(location: decLocX, length: decLength)
        plotSpace.xRange = xRange
        let percentY = 0.25
        let lengthY = self.distance
        let locY = self.data.y.min()! - lengthY * percentY / 2.0
        var additinal  = 1.0
        if (self.data.y.max()! - self.data.y.min()!) < 0.00001 {
            additinal = 0
        }
        
        let yPlotRange = CPTPlotRange(location: NSNumber(value: Float(locY)), length: NSNumber(value: Float(lengthY * (additinal + percentY))))
        plotSpace.yRange = yPlotRange
        print("PLOTRANGE: \(yPlotRange)")
        
    }
    
    func getData(afterCache: Bool = false){
        //        print("Getting Data")
        //        let importInProgress = User.instance.importInProgress ?? false
        //        if self.userGraph && importInProgress {
        //            self.labelChartNotAvailable.text = "Loading your account"
        //            self.labelChartNotAvailable.isHidden = false
        //            self.selectedIndex = nil
        //            self.graphView.isHidden = true
        //            labelMainSelectedValue.text = ""
        //            labelSelectedPoint.text = ""
        //        } else {
        //            if !afterCache {
        //                self.viewContainerGraph.backgroundColor = nil
        //                self.labelChartNotAvailable.isHidden = true
        //                self.graphView.isHidden = true
        //
        //            }
        //
        //                        TODO:
        //         dataSource?.dataForGraph(section: selectedDataIndex.rawValue, completionHandler: self.loadGraph)
        //        }
        dataSource?.dataForGraph(section: selectedDataIndex.rawValue, completionHandler: self.loadGraph)
    }
    
    func loadGraph(data:( x:[Double], y:[Double], y1:[Double],balance:[Double]), allPoints: Bool) {
        print("Loading graph")
        
        //        let importInProgress = User.instance.importInProgress ?? false
        //        print("importInProgress " + (importInProgress.description ) + " userGraph " + (self.userGraph.description ))
        //        if self.userGraph && importInProgress {
        //            self.labelChartNotAvailable.text = "Loading your account"
        //            self.labelChartNotAvailable.isHidden = false
        //            self.selectedIndex = nil
        //            self.graphView.isHidden = true
        //            labelMainSelectedValue.text = ""
        //            labelSelectedPoint.text = ""
        //        } else {
        DispatchQueue.main.async() {
            self.data = data
            self.isAllPoints = allPoints
            if self.data.x.count > 0 {
                print(data.x.count)
                //prepare data for graph
                let yMax = abs( self.data.y.max()! )
                self.distance = abs( self.data.y.max()! - self.data.y.min()! )
                if self.distance < 0.000001 {
                    self.distance = yMax * 0.25
                }
                self.additionalValueY = yMax + self.distance * 0.25
                
                for indexY in 0...self.data.y.count-1 {
                    self.data.y[indexY] = self.data.y[indexY] - self.additionalValueY
                }
                
                if (self.data.y.max()! + self.additionalValueY) < -0.0001 {
                    self.zeroLineValueY = self.data.y.max()! + self.distance * 0.1
                } else {
                    if (self.data.y.min()! + self.additionalValueY) > -0.0001 {
                        self.zeroLineValueY = self.data.y.min()! - self.distance * 0.1
                    } else {
                        self.zeroLineValueY = -self.additionalValueY
                    }
                }
                self.zeroLineValueY = self.data.y[0]
                self.labelChartNotAvailable.isHidden = true
                self.selectedIndex = UInt(data.x.count - 1)
                
                self.graphView.isHidden = false
                
                self.setRangeForGraph()
                //                self.graphView.backgroundColor = UIColor(patternImage: UIImage.getHatchingImage(size: self.view.frame.size, backgroundColor: UIColor.blue))
                
                self.formatLabelSelectedPoint(showDate: false)
                self.graph.reloadData()
            } else {
                self.labelChartNotAvailable.isHidden = false
                self.selectedIndex = nil
                self.graphView.isHidden = true
            }
            //            }
        }
    }
    
    
    
    func formatLabelSelectedPoint(showDate:Bool){
        //$8.27 | 0.00 | 0.00% 11/17/15, 04:01 PM
        
    }
    
}

extension TDGraphBaseViewController : CPTScatterPlotDataSource {
    /** @brief @required The number of data points for the plot.
     *  @param plot The plot.
     *  @return The number of data points for the plot.
     **/
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        let plotId = plot.identifier as! String
        if plotId  == idMainPlot {
            return UInt(data.x.count)
        } else if plotId  == idSelectedPoint || plotId == idAreaSelectedPoint {
            if selectedIndex == nil {
                return 0
            } else {
                return 1
            }
        } else if plotId  == idZeroLine {
            return UInt(maxX*2)
            
        } else if plotId == idHideous1DLine && selectedDataIndex == .Day {
            return UInt(maxX*2)
        }
        return 0
        
    }
    
    func number(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Any? {
        let plotField = CPTScatterPlotField(rawValue: Int(fieldEnum))!
        let plotId = plot.identifier as! String
        
        if plotId == idMainPlot {
            switch plotField {
            case CPTScatterPlotField.X:
                return Int(idx)
            case CPTScatterPlotField.Y:
                return data.y[Int(idx)] as AnyObject?
            }
        } else if plotId == idSelectedPoint || plotId == idAreaSelectedPoint {
            switch plotField {
            case CPTScatterPlotField.X:
                return Int(selectedIndex!)
            case CPTScatterPlotField.Y:
                return data.y[Int(selectedIndex!)]
            }
        } else if plotId == idZeroLine {
            switch plotField {
            case CPTScatterPlotField.X:
                return Int(idx)
            case CPTScatterPlotField.Y:
                return zeroLineValueY
            }
        }
            //     Set baseline angled lines for end of graph data
        else if plotId == idHideous1DLine {
            switch plotField {
            case CPTScatterPlotField.X:
                return data.x.count + Int(idx) - 1
            case CPTScatterPlotField.Y:
                return zeroLineValueY
            }
        }
        return 0
    }
    
}

extension TDGraphBaseViewController : CPTScatterPlotDelegate {
    
    func scatterPlot(_ plot: CPTScatterPlot, plotSymbolWasSelectedAtRecord idx: UInt){
        //        self.makeSelection(plot: plot, plotSymbolWasSelectedAtRecordIndex: idx)
    }
    
    func symbol(for plot: CPTScatterPlot, record idx: UInt) -> CPTPlotSymbol? {
        let lineAreaStyleSelectionPoint = CPTMutableLineStyle()
        lineAreaStyleSelectionPoint.lineWidth = 0.0
        lineAreaStyleSelectionPoint.lineColor = CPTColor(componentRed: 5.0/255.0, green: 37.0/255.0, blue: 49.0/255.0, alpha: 1.0)
        
        if plot.identifier as! String  == idSelectedPoint && idx == 0 {
            let res = CPTPlotSymbol()
            res.symbolType = CPTPlotSymbolType.ellipse
            res.size = CGSize(width: 12, height: 12)
            res.lineStyle = lineAreaStyleSelectionPoint
            res.fill = CPTFill(color: CPTColor(componentRed: 38.0/255.0, green: 148.0/255.0, blue: 171.0/255.0, alpha: 1.0))
            return res
        }
        
        if plot.identifier as! String  == idAreaSelectedPoint && idx == 0 {
            let res = CPTPlotSymbol()
            res.symbolType = CPTPlotSymbolType.ellipse
            res.size = CGSize(width: 24, height: 24)
            res.fill = CPTFill(color: CPTColor(componentRed: 5.0/255.0, green: 37.0/255.0, blue: 49.0/255.0, alpha: 1.0))
            res.lineStyle = lineAreaStyleSelectionPoint
            return res
        }
        
        return nil
    }
    
    func symbolForScatterPlot(plot: CPTPlot!, recordIndex: UInt) -> CPTPlotSymbol? {
        let lineAreaStyleSelectionPoint           = CPTMutableLineStyle()
        lineAreaStyleSelectionPoint.lineWidth     = 0.0
        lineAreaStyleSelectionPoint.lineColor     = CPTColor(componentRed: 5.0/255.0, green: 37.0/255.0, blue: 49.0/255.0, alpha: 1.0)
        
        if plot.identifier as! String  == idSelectedPoint && recordIndex == 0 {
            let res = CPTPlotSymbol()
            res.symbolType = CPTPlotSymbolType.ellipse
            res.size = CGSize(width: 12, height: 12)
            res.lineStyle = lineAreaStyleSelectionPoint
            //            res.fill = CPTFill(color: CPTColor(componentRed: 38.0/255.0, green: 148.0/255.0, blue: 171.0/255.0, alpha: 1.0))
            res.fill = CPTFill(color: CPTColor(cgColor: UIColor.red.cgColor))
            return res
        }
        
        if plot.identifier as! String  == idAreaSelectedPoint && recordIndex == 0 {
            let res = CPTPlotSymbol()
            res.symbolType = CPTPlotSymbolType.ellipse
            res.size = CGSize(width: 24, height: 24)
            //            res.fill = CPTFill(color: CPTColor(componentRed: 5.0/255.0, green: 37.0/255.0, blue: 49.0/255.0, alpha: 1.0))
            res.fill = CPTFill(color: CPTColor(cgColor: UIColor.red.cgColor))
            res.lineStyle = lineAreaStyleSelectionPoint
            return res
        }
        
        return nil
    }
    
}

extension TDGraphBaseViewController : CPTPlotSpaceDelegate {
    
    func plotSpace(_ space: CPTPlotSpace, shouldHandlePointingDeviceDraggedEvent event: UIEvent, at point: CGPoint) -> Bool {
        if let p = space.plotPoint(forPlotAreaViewPoint: point), p.count > 0 {
            let idx = UInt(round(Double(p[0])))
            if idx < UInt(data.x.count) {
                self.makeSelection(plot: plot, plotSymbolWasSelectedAtRecordIndex: idx)
            }
        }
        return true
    }
    
    func plotSpace(_ space: CPTPlotSpace, shouldHandlePointingDeviceUp event: UIEvent, at point: CGPoint) -> Bool {
        return true
    }
    
    func plotSpace(_ space: CPTPlotSpace, shouldHandlePointingDeviceDownEvent event: UIEvent, at point: CGPoint) -> Bool {
        let idx = plot.indexOfVisiblePointClosest(toPlotAreaPoint: point)
        if idx < UInt(data.x.count) {
            self.makeSelection(plot: plot, plotSymbolWasSelectedAtRecordIndex: idx)
        }
        return true
    }
    
    func makeSelection(plot: CPTScatterPlot, plotSymbolWasSelectedAtRecordIndex idx: UInt) {
        let plotId = plot.identifier as! String
        if plotId == idMainPlot {
            //            #if DEBUG
            //                print("selected point \(idx)")
            //            #endif
            
            let needReloadAllData = selectedIndex == nil
            selectedIndex = idx
            graph.plot(withIdentifier: idSelectedPoint as NSCopying?)?.reloadPlotData()
            graph.plot(withIdentifier: idAreaSelectedPoint as NSCopying?)?.reloadPlotData()
            if needReloadAllData {
                graph.reloadData()
            }
            formatLabelSelectedPoint(showDate: false)
        }
    }
}
