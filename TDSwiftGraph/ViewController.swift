//
//  ViewController.swift
//  TDSwiftGraph
//
//  Created by Tieshow Daniels on 4/17/17.
//  Copyright © 2017 Ty Daniels. All rights reserved.
//

import UIKit
import Stevia

class ViewController: UIViewController, TDGraphViewControllerDataSource {
    
    // MARK: - Custom Controllers
    var tdGraphNewViewController = TDGraphNewController()
    
    // MARK: - View objects
    var graphWindow = UIView()
    
    // MARK: - View data
    var lastSection = -1

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up graph data
        tdGraphNewViewController.dataSource = self
        tdGraphNewViewController.userGraph = true
        
        setupGraph()
    }
    
    //Setup graph layout/embed the graph within a UIView subviewed onto the viewcontroller
    fileprivate func setupGraph() {
        
        tdGraphNewViewController.view.frame = graphWindow.bounds // Set graph frame to embedded UIView
        
        view.sv(graphWindow)
        view.layout(
            0,
            |graphWindow| ~ view.frame.height / 2 // Graph container height
        )
        
        // MARK: - Additional layouts
        
        view.backgroundColor = UIColor.white
        
        EmbedChildViewController.embed(viewControllerId: tdGraphNewViewController, containerViewController: self, containerView: graphWindow) // Embed the graph within UIView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Graph protocols
    
    func dataForGraph(section: Int, completionHandler: @escaping ((x: [Double], y: [Double], y1: [Double], balance: [Double]), Bool) -> Void) {
        
//        if lastSection != section {
//            cacheFired = false
//        }
        
        // NOTE: - Spoofed data
        self.lastSection = section
        print(section)
        
        //         Add some initial data
        var xArr = [Double]()
        var yArr = [Double]()
        var yyArr = [Double]()
        var balanceArr = [Double]()
        for i in 0 ..<  40 { // Plot 40 random data points
            let x = NSDate().timeAgoForFeed
            let y = 1.2 * Double(arc4random()) / Double(UInt32.max) + 1.2
            let bal = Double(arc4random_uniform(UInt32(25.00))) + 2
            xArr.append(NSDate().timeIntervalSince1970)
            yArr.append(y)
            yyArr.append(0.0)
            balanceArr.append(bal)
        }
        
        let dataArr = (x: xArr, y: yArr, y1: yyArr, balance: balanceArr)
        
        completionHandler(dataArr, false)
    }


}

