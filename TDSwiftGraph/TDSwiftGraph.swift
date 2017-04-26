//
//  TDSwiftGraph.swift
//  TDSwiftGraph
//
//  Created by Tieshow Daniels on 4/26/17.
//  Copyright © 2017 Ty Daniels. All rights reserved.
//

import Foundation
import CorePlot
import UIKit

class TDGraphView: CPTGraphHostingView {
    
    @IBInspectable open var mainLineColor: UIColor {
        get {
            return graphLayer.mainLineColor
        }
        set {
            graphLayer.mainLineColor = newValue
            graphLayer.setNeedsDisplay()
        }
    }

    // MARK: - Custom Base Layer
    fileprivate var graphLayer: GraphLayer! {
        get {
            let viewLayer = layer as! GraphLayer
            viewLayer.hostingView = self
            viewLayer.frame = self.bounds
            return viewLayer
        }
    }


    // MARK: - Private Classes / Structs
    class GraphLayer: CPTXYGraph {
        @NSManaged var zeroLineColor: UIColor
        @NSManaged var mainLineColor: UIColor
        @NSManaged var dotIndicatorColor: UIColor?
        
        @NSManaged var indeterminateProgress: CGFloat
        // This needs to have a setter/getter for it to work with CoreAnimation
        @NSManaged var progress: CGFloat
        
        override func draw(in ctx: CGContext) {
            
            var plot = CPTScatterPlot()
            let selectionPlot = CPTScatterPlot()
            let areaSelectionPlot = CPTScatterPlot()
            var zeroLine = CPTScatterPlot()
            var hideousLine = CPTScatterPlot()
            var hideousLine2 = CPTScatterPlot()
            
            let idMainPlot = "main_plot"
            let idSelectedPoint = "selected_point"
            let idAreaSelectedPoint = "area_selected_point"
            let idZeroLine = "zeroLine"
            let idHideous1DLine = "idHideous1DLine"
            
            self.axisSet = nil
            
            // hide paddings
            self.paddingLeft = 0.0
            self.paddingTop = 0.0
            self.paddingRight = 0.0
            self.paddingBottom = 0.0
            
            //Plot to fill area in 1D graph
//            hideousLine.dataSource = self
            hideousLine.identifier = idHideous1DLine as (NSCoding & NSCopying & NSObjectProtocol)?
            let hideousLineStyle = CPTMutableLineStyle()
            hideousLineStyle.lineWidth = 2.5
            hideousLineStyle.lineColor = CPTColor(componentRed: 0, green: 0, blue: 0, alpha: 0.0)
            hideousLine.dataLineStyle = hideousLineStyle
            hideousLine.areaBaseValue = NSNumber(value: 2.0)
            hideousLine.areaBaseValue2 = NSNumber(value: -2.0)
            hideousLine.areaFill = CPTFill(color: CPTColor(cgColor: mainLineColor as! CGColor))
            self.add(hideousLine)
            
//                        hideousLine2.dataSource = self
            hideousLine2.identifier = idHideous1DLine as (NSCoding & NSCopying & NSObjectProtocol)?
            let hideousLineStyle2 = CPTMutableLineStyle()
            hideousLineStyle2.lineWidth = 2.5
            hideousLineStyle2.lineColor = CPTColor(componentRed: 0, green: 0, blue: 0, alpha: 0.0)
            hideousLine2.dataLineStyle = hideousLineStyle2
            hideousLine2.areaBaseValue = NSNumber(value: -2.0)
            hideousLine2.areaFill = CPTFill(color: CPTColor(cgColor: mainLineColor as! CGColor))
            self.add(hideousLine2)
            
            //main plot
            let lineStyle = CPTMutableLineStyle()
            lineStyle.lineWidth = 2.5
            //        lineStyle.lineColor = mainLineColor
            plot.identifier = idMainPlot as (NSCoding & NSCopying & NSObjectProtocol)?
            plot.dataLineStyle = lineStyle
            //            plot.dataSource = self
            //            plot.delegate = self
            plot.plotSymbolMarginForHitDetection = 10
            plot.paddingLeft = 0.0
            plot.paddingTop = 0.0
            plot.paddingRight = 0.0
            plot.paddingBottom = 0.0
            plot.areaBaseValue = NSNumber(value: 2.0)
            plot.areaFill = CPTFill(color: CPTColor(cgColor: mainLineColor as! CGColor))
            self.add(plot)
            
            
            //zero line
            //            zeroLine.dataSource = self
            zeroLine.identifier = idZeroLine as (NSCoding & NSCopying & NSObjectProtocol)?
            let zeroLineStyle = CPTMutableLineStyle()
            zeroLineStyle.lineWidth = 2.5
            //        zeroLineStyle.lineColor = mainLineColor
            zeroLineStyle.dashPattern = [NSNumber(cgFloat: 3), NSNumber(cgFloat: 3)]
            zeroLine.dataLineStyle = zeroLineStyle
            self.add(zeroLine)
            
            // Selection Marker Area
//            areaSelectionPlot.dataSource = self
            areaSelectionPlot.identifier = idAreaSelectedPoint as (NSCoding & NSCopying & NSObjectProtocol)?
            areaSelectionPlot.cachePrecision = CPTPlotCachePrecision.double
            let lineAreaStyleSelectionPoint = CPTMutableLineStyle()
            lineAreaStyleSelectionPoint.lineWidth = 0.0
            //        lineAreaStyleSelectionPoint.lineColor = mainLineColor
            areaSelectionPlot.dataLineStyle = lineAreaStyleSelectionPoint
            self.add(areaSelectionPlot)
            
            // Selection Marker
            selectionPlot.identifier = idSelectedPoint as (NSCoding & NSCopying & NSObjectProtocol)?
            selectionPlot.cachePrecision = CPTPlotCachePrecision.double
            let lineStyleSelectionPoint = CPTMutableLineStyle()
            lineStyleSelectionPoint.lineWidth = 3.0
            //        lineStyleSelectionPoint.lineColor = mainLineColor
            selectionPlot.dataLineStyle = lineStyleSelectionPoint
//            selectionPlot.dataSource = self
            self.add(selectionPlot)
            
//            if !fromWatchlist{
//                maketBarItemSelected(index: 0)
//            }else{
//                selectedDataIndex = CustomTimeInterval.Year
//                maketBarItemSelected(index: 4)
//                
//            }
            
            //            labelMainSelectedValue.text = ""
            //            graph.defaultPlotSpace?.delegate = self
            //            getData()
            
//            func maketBarItemSelected(index: Int) -> Void {
//                barButtonItem1D.tintColor = UIColor.white
//                barButtonItem1M.tintColor = UIColor.white
//                barButtonItem3M.tintColor = UIColor.white
//                barButtonItem6M.tintColor = UIColor.white
//                barButtonItem1Y.tintColor = UIColor.white
//                switch index {
//                case 0:
//                    barButtonItem1D.tintColor = mainLineColor.uiColor
//                    break
//                case 1:
//                    barButtonItem1M.tintColor = mainLineColor.uiColor
//                    break
//                case 2:
//                    barButtonItem3M.tintColor = mainLineColor.uiColor
//                    break
//                case 3:
//                    barButtonItem6M.tintColor = mainLineColor.uiColor
//                    break
//                case 4:
//                    barButtonItem1Y.tintColor = mainLineColor.uiColor
//                    break
//                default:
//                    break
//                }
//

        }
    }
}

extension CPTGraphHostingView : CPTScatterPlotDataSource {
    /** @brief @required The number of data points for the plot.
     *  @param plot The plot.
     *  @return The number of data points for the plot.
     **/
    public func numberOfRecords(for plot: CPTPlot) -> UInt {
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
    
    public func number(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Any? {
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

extension CPTGraphHostingView : CPTScatterPlotDelegate {
    
    public func scatterPlot(_ plot: CPTScatterPlot, plotSymbolWasSelectedAtRecord idx: UInt){
        //        self.makeSelection(plot: plot, plotSymbolWasSelectedAtRecordIndex: idx)
    }
    
    public func symbol(for plot: CPTScatterPlot, record idx: UInt) -> CPTPlotSymbol? {
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

extension CPTGraphHostingView : CPTPlotSpaceDelegate {
    
    public func plotSpace(_ space: CPTPlotSpace, shouldHandlePointingDeviceDraggedEvent event: UIEvent, at point: CGPoint) -> Bool {
        if let p = space.plotPoint(forPlotAreaViewPoint: point), p.count > 0 {
            let idx = UInt(round(Double(p[0])))
            if idx < UInt(data.x.count) {
                self.makeSelection(plot: plot, plotSymbolWasSelectedAtRecordIndex: idx)
            }
        }
        return true
    }
    
    public func plotSpace(_ space: CPTPlotSpace, shouldHandlePointingDeviceUp event: UIEvent, at point: CGPoint) -> Bool {
        return true
    }
    
    public func plotSpace(_ space: CPTPlotSpace, shouldHandlePointingDeviceDownEvent event: UIEvent, at point: CGPoint) -> Bool {
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
