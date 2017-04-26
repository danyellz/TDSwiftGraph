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

open class TDGraphView: CPTGraphHostingView {
    
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
            hideousLine.areaFill = CPTFill(color: CPTColor(cgColor: UIColor.blue.cgColor))
            self.add(hideousLine)
            
//                        hideousLine2.dataSource = self
            hideousLine2.identifier = idHideous1DLine as (NSCoding & NSCopying & NSObjectProtocol)?
            let hideousLineStyle2 = CPTMutableLineStyle()
            hideousLineStyle2.lineWidth = 2.5
            hideousLineStyle2.lineColor = CPTColor(componentRed: 0, green: 0, blue: 0, alpha: 0.0)
            hideousLine2.dataLineStyle = hideousLineStyle2
            hideousLine2.areaBaseValue = NSNumber(value: -2.0)
            hideousLine2.areaFill = CPTFill(color: CPTColor(cgColor: UIColor.blue.cgColor))
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
            plot.areaFill = CPTFill(color: CPTColor(cgColor: UIColor.blue.cgColor))
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
