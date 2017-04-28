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
    
    var delegate: UIViewController?
    
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
            let viewLayer = GraphLayer()
            viewLayer.graphDelegate = delegate
            viewLayer.setupGraph()
            return viewLayer
        }
    }


    // MARK: - Private Classes / Structs
    class GraphLayer: CPTXYGraph {
        @NSManaged var zeroLineColor: UIColor
        @NSManaged var mainLineColor: UIColor
        @NSManaged var dotIndicatorColor: UIColor?
        
        var graphDelegate: UIViewController?
        
        func setupGraph() {
        
            var plot = CPTScatterPlot()
            let selectionPlot = CPTScatterPlot()
            let areaSelectionPlot = CPTScatterPlot()
            var zeroLine = CPTScatterPlot()
            var hideousLine = CPTScatterPlot()
            var hideousLine2 = CPTScatterPlot()
            
            var labelMainSelectedValue = UILabel()
            var labelSelectedPoint = UILabel()
            
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
            hideousLine.dataSource = graphDelegate as? CPTPlotDataSource
            hideousLine.identifier = idHideous1DLine as (NSCoding & NSCopying & NSObjectProtocol)?
            let hideousLineStyle = CPTMutableLineStyle()
            hideousLineStyle.lineWidth = 2.5
            hideousLineStyle.lineColor = CPTColor(componentRed: 0, green: 0, blue: 0, alpha: 0.0)
            hideousLine.dataLineStyle = hideousLineStyle
            hideousLine.areaBaseValue = NSNumber(value: 2.0)
            hideousLine.areaBaseValue2 = NSNumber(value: -2.0)
            hideousLine.areaFill = CPTFill(color: CPTColor(cgColor: mainLineColor.cgColor))
            self.add(hideousLine)
            
            hideousLine2.dataSource = graphDelegate as? CPTPlotDataSource
            hideousLine2.identifier = idHideous1DLine as (NSCoding & NSCopying & NSObjectProtocol)?
            let hideousLineStyle2 = CPTMutableLineStyle()
            hideousLineStyle2.lineWidth = 2.5
            hideousLineStyle2.lineColor = CPTColor(componentRed: 0, green: 0, blue: 0, alpha: 0.0)
            hideousLine2.dataLineStyle = hideousLineStyle2
            hideousLine2.areaBaseValue = NSNumber(value: -2.0)
            hideousLine2.areaFill = CPTFill(color: CPTColor(cgColor: mainLineColor.cgColor))
            self.add(hideousLine2)
            
            //main plot
            let lineStyle = CPTMutableLineStyle()
            lineStyle.lineWidth = 2.5
            //        lineStyle.lineColor = mainLineColor
            plot.identifier = idMainPlot as (NSCoding & NSCopying & NSObjectProtocol)?
            plot.dataLineStyle = lineStyle
            plot.dataSource = graphDelegate as? CPTPlotDataSource
            plot.delegate = graphDelegate as? CALayerDelegate
            plot.plotSymbolMarginForHitDetection = 10
            plot.paddingLeft = 0.0
            plot.paddingTop = 0.0
            plot.paddingRight = 0.0
            plot.paddingBottom = 0.0
            plot.areaBaseValue = NSNumber(value: 2.0)
            plot.areaFill = CPTFill(color: CPTColor(cgColor: mainLineColor.cgColor))
            self.add(plot)
            
            
            //zero line
            zeroLine.dataSource = graphDelegate as? CPTPlotDataSource
            zeroLine.identifier = idZeroLine as (NSCoding & NSCopying & NSObjectProtocol)?
            let zeroLineStyle = CPTMutableLineStyle()
            zeroLineStyle.lineWidth = 2.5
            zeroLineStyle.lineColor = CPTColor(componentRed: 38.0/255.0, green: 148.0/255.0, blue: 171.0/255.0, alpha: 1.0)
            zeroLineStyle.dashPattern = [NSNumber(cgFloat: 3), NSNumber(cgFloat: 3)]
            zeroLine.dataLineStyle = zeroLineStyle
            self.add(zeroLine)
            
            // Selection Marker Area
            areaSelectionPlot.dataSource = graphDelegate as? CPTPlotDataSource
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
            selectionPlot.dataSource = graphDelegate as? CPTPlotDataSource
            self.add(selectionPlot)
        }
    }
    
    // Lifecycle
    /**
     Default initializer for the class
     - returns: A configured instance of self
     */
    required public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        
        setupDefaults()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupDefaults()
    }
    
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if let window = window {
            graphLayer.contentsScale = window.screen.scale
            graphLayer.setNeedsDisplay()
        }
    }
}

private extension TDGraphView {
        
    // MARK: - Defaults
    func setupDefaults() {
        
        self.hostedGraph = graphLayer
        graphLayer.defaultPlotSpace?.delegate = delegate as? CPTPlotSpaceDelegate
        graphLayer.mainLineColor = UIColor.yellow
        graphLayer.zeroLineColor = UIColor.yellow
        graphLayer.dotIndicatorColor = UIColor.yellow
    }
}
